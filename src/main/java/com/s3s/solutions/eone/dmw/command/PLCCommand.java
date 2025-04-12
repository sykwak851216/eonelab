package com.s3s.solutions.eone.dmw.command;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import org.apache.commons.lang3.StringUtils;

import com.s3s.sfp.dmw.message.EMessageType;
import com.s3s.sfp.dmw.message.EParamType;
import com.s3s.sfp.dmw.message.annotation.MessageComponent;
import com.s3s.sfp.dmw.message.annotation.MessageListener;
import com.s3s.sfp.dmw.message.annotation.MessageParam;
import com.s3s.sfp.tools.NumberTools;
import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.biz.OrderBizService;
import com.s3s.solutions.eone.biz.OrderOperationHistoryBizService;
import com.s3s.solutions.eone.biz.OrderWorkBizService;
import com.s3s.solutions.eone.biz.TrayLocationBizService;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EWorkStatus;
import com.s3s.solutions.eone.dmw.command.message.body.BufferReportBody;
import com.s3s.solutions.eone.dmw.command.message.body.GantryReportBody;
import com.s3s.solutions.eone.dmw.command.message.body.InHounseTrayBody;
import com.s3s.solutions.eone.dmw.command.message.body.OrderReportBody;
import com.s3s.solutions.eone.manager.PLCManager;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.TrayDuplicateLocationService;
import com.s3s.solutions.eone.service.wmd.trayduplicatelocation.TrayDuplicateLocationVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;


@MessageComponent(messageType=EMessageType.REPORT)
@RequiredArgsConstructor
@Slf4j
public class PLCCommand {

	private static Map<String, GantryReportBody> gantryStatus = new HashMap<String,GantryReportBody>();
	private static Map<String, OrderReportBody> orderStatus = new HashMap<String,OrderReportBody>();
	private static Map<String, BufferReportBody> bufferStatus = new HashMap<String,BufferReportBody>();

	private final OrderBizService orderBizService;

	private final OrderWorkBizService orderWorkBizService;

	private final OrderWorkService orderWorkService;

	private final OrderOperationHistoryBizService orderOperationHistoryBizService;

	private final PLCManager plcManager;
	
	private final TrayLocationBizService trayLocationBizService;
	
	private final TrayDuplicateLocationService trayDuplicateLocationService;
	
	@MessageListener("buffer")
	public void getBufferReport(@MessageParam(EParamType.SYSTEM_ID) String systemId, @MessageParam(EParamType.MESSAGE) BufferReportBody newBuffer) {
		try {
			if (StringUtils.equals(newBuffer.getBufferTargetLocation(), "7") && StringUtils.equals(newBuffer.getBufferOperationMode(), "2")) {	
				//이하 로직은 호출 업무의 반출 진행중일 경우 버퍼에서 셀을 꺼냈을 경우 조회 수량을 처리해 주기 위함이다.
				OrderVO completeOutputOrderByInquiry = orderBizService.getOutputOrderByIngInquiryOrderGroup(systemId);
				if(completeOutputOrderByInquiry != null) {
					BufferReportBody beforeBuffer = getBuffer(systemId); //이전의 버퍼값
					
					Map<String, String> beforeBufferStatus = beforeBuffer.getBufferCellStatus(); //이전의 버퍼 셀 상태
					Map<String, String> newBufferStatus = newBuffer.getBufferCellStatus(); //새로 들어온 버퍼 셀 상태
					
					Map<String, Integer> inquiryMap = new HashMap<String, Integer>(); //반출 처리해야할 버퍼셀 목록
					IntStream.range(1, 13).forEach(i->{
						String bufferId = String.valueOf(i);
						String beforeCellStatus = beforeBufferStatus.get(bufferId);
						String newCellStatus = newBufferStatus.get(bufferId);
						//이전에 박스가 있다가 없어지면.
						if(StringUtils.equals(beforeCellStatus, EoneConst.BOX_ON) && StringUtils.equals(newCellStatus, EoneConst.BOX_OFF)) {
							inquiryMap.put(bufferId, 1);
						}
					});

					List<OrderWorkVO> workList = orderWorkBizService.getOrderWorkListByOrder(completeOutputOrderByInquiry);
					//요걸 받아서. 해당 work에 넣는다.
					for(String bufferId : inquiryMap.keySet()) {
						OrderWorkVO work = workList.stream()
								.filter(o -> StringUtils.equals(bufferId, o.getBufferId()) && StringUtils.equals(o.getWorkStatusCd(), EWorkStatus.COMPLETE.name()))
								.findFirst().orElseGet(null); //현재 작업 상태가 완료(COMPLETE) 상태인 작업지시
						if(work != null && isBufferOnWorkingstation(systemId)) {
							int inquiryQty = NumberTools.nullToZero(work.getInquiryQty()) + 1;
							work.setInquiryQty(inquiryQty);
						}
						orderWorkService.modify(work);
					}
				}
			}
			
			//if (StringUtils.equals(newBuffer.getBufferTargetLocation(), "1") && StringUtils.equals(newBuffer.getBufferOperationMode(), "2")) {
			//이하 로직은 호출 업무의 
			if (StringUtils.equals(newBuffer.getBufferOperationMode(), "2")) {
				OrderVO ingOutputOrder = orderBizService.getOutputOrderByIngOrderGroup(systemId);
				
				if(ingOutputOrder != null) {
					BufferReportBody beforeBuffer = getBuffer(systemId); //이전의 버퍼값
					
					Map<String, String> beforeBufferStatus = beforeBuffer.getBufferCellStatus(); //이전의 버퍼 셀 상태
					Map<String, String> newBufferStatus = newBuffer.getBufferCellStatus(); //새로 들어온 버퍼 셀 상태
					Map<String, Integer> outputCompleteTrayMap = new HashMap<String, Integer>(); //반출 완료 처리해야 할 버퍼셀 목록
					IntStream.range(1, 13).forEach(i->{
						String bufferId = String.valueOf(i);
						String beforeCellStatus = beforeBufferStatus.get(bufferId);
						String newCellStatus = newBufferStatus.get(bufferId);
						//셔틀에 렉이 적재 됐을 경우
						if(StringUtils.equals(beforeCellStatus, EoneConst.BOX_OFF) && StringUtils.equals(newCellStatus, EoneConst.BOX_ON)) {
							outputCompleteTrayMap.put(bufferId, 1);
						}
					});
					log.info("[buffer] ****"+outputCompleteTrayMap.size());
					List<OrderWorkVO> workList = orderWorkBizService.getOrderWorkListByOrder(ingOutputOrder);
					for(String bufferId : outputCompleteTrayMap.keySet()) {
						OrderWorkVO work = workList.stream()
								.filter(o -> StringUtils.equals(bufferId, o.getBufferId()) && StringUtils.equals(o.getWorkStatusCd(), EWorkStatus.READY.name()))
								.findFirst().orElseGet(null);
						
						log.info("[buffer] ****"+work.toString());
						if(work != null) {
							orderWorkBizService.workComplete(work, ingOutputOrder);
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		setBuffer(systemId, newBuffer);
	}

	@MessageListener("gantry")
	public void getGantryReport(@MessageParam(EParamType.SYSTEM_ID) String systemId, @MessageParam(EParamType.MESSAGE) GantryReportBody vo) {
		log.info("GantryReportBody - " + vo.toString());
		setGantry(systemId, vo);
	}
	
	@MessageListener("order")
	public void getOrderReport(@MessageParam(EParamType.SYSTEM_ID) String systemId, @MessageParam(EParamType.MESSAGE) OrderReportBody changeOrder) {
		log.info("OrderReportBody - " + changeOrder.toString());
		//for test
		//changeOrder.setOrderNo(200623172505345011l);
		
		setOrder(systemId, changeOrder);
		if(changeOrder.getOrderNo() != 0l) {
			try {
				OrderVO order = orderBizService.getOrderById(String.valueOf(changeOrder.getOrderNo()));
				//오더가 없으면 반환
				if(order != null) {
					//현재 들어온 지시의 처리상태가 진행중이거나 완료일 경우
					if(StringUtils.equals(changeOrder.getOrderProcStatus(), EOrderStatus.ING.getCode()) || StringUtils.equals(changeOrder.getOrderProcStatus(), EOrderStatus.COMPLETE.getCode())) {
						int workQty = 0;
						workQty = orderWorkBizService.trayProcess(order, changeOrder); //입고 완료된 수
						//log.debug("workQty="+workQty);
						if (StringUtils.equals(changeOrder.getOrderProcStatus(), EOrderStatus.ING.getCode())) {
							order.setChangeWorkTrayQty(workQty);
							orderBizService.orderStart(order);   
						} else if (StringUtils.equals(changeOrder.getOrderProcStatus(), EOrderStatus.COMPLETE.getCode())) {
							order.setChangeWorkTrayQty(workQty);
							/*
							if (StringUtils.equals(order.getOrderTypeCd(), EOrderType.OUTPUT.name()) == false) {
								orderBizService.orderComplete(order);
							}
							*/
							if (order.getOrderTrayQty() == workQty) {
								orderBizService.orderComplete(order);
							}
						}
					}

					orderOperationHistoryBizService.updateOperationHistoryByPlc(order, changeOrder);
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void setGantry(String systemId, GantryReportBody vo) {
		gantryStatus.put(systemId, vo);
	}

	public static GantryReportBody getGantry(String systemId) {
		return gantryStatus.get(systemId);
	}

	public static void setOrder(String systemId, OrderReportBody vo) {
		orderStatus.put(systemId, vo);
	}

	/**
	 * 현재 지시정보 조회
	 * @param systemId : 라인번호와 동일
	 * @return 현재 지시정보
	 */
	public static OrderReportBody getOrder(String systemId) {
		return orderStatus.get(systemId);
	}

	public static void setBuffer(String systemId, BufferReportBody vo) {
		bufferStatus.put(systemId, vo);
	}

	public static BufferReportBody getBuffer(String systemId) {
		return bufferStatus.get(systemId);
	}


	/*
	public static boolean isBufferOnWorkingstation() {
		BufferReportBody buffer = getBuffer();
		//타겟 위치가 워킹존이고 동작 모드가 이동 완료일 경우
		if(StringUtils.equals(buffer.getBufferTargetLocation(), "7") && StringUtils.equals(buffer.getBufferOperationMode(), "2")) {
			return true;
		}
		return false;
	}
	*/
	
	/**
	 * 셔틀위치 정보의 목표 위치가 워킹존(7)이고 동작 모드가 이동 완료(2)일 경우
	 * @param lineNo
	 * @return
	 */
	public static boolean isBufferOnWorkingstation(String lineNo) {
		BufferReportBody buffer = new BufferReportBody();
		buffer = getBuffer(lineNo);
		
		//타겟 위치가 워킹존이고 동작 모드가 이동 완료일 경우
		if(StringUtils.equals(buffer.getBufferTargetLocation(), "7") && StringUtils.equals(buffer.getBufferOperationMode(), "2")) {
			return true;
		}
		return false;
	}


	
	public static String getBufferPosition(String lineNo) {
		BufferReportBody buffer = new BufferReportBody();
		buffer = getBuffer(lineNo);
		//이동 완료이면 목표 위치를 반환
		if(StringUtils.equals(buffer.getBufferOperationMode(), "2")) {
			return buffer.getBufferTargetLocation();
		}
		//이동 중이면
		else if(StringUtils.equals(buffer.getBufferOperationMode(), "1")) {
			return buffer.getBufferPreLocation();
		}
		//대기이면.
		else {
			return buffer.getBufferTargetLocation();
		}
	}
	
	
	/**
	 * 
	 * @param lineNo
	 * @return
	 */
	public static String isCallOrderByLineNo(String lineNo) {
		OrderReportBody orderStatus = new OrderReportBody();
		orderStatus = getOrder(lineNo);
		//1:닫힘, 2:열림
		if(StringUtils.equals(orderStatus.getDoorStatus(), "2")) {
			return "1";
		}
		
		GantryReportBody gantry = getGantry(lineNo);
		//겐트리 상태가 1:정상이고, 동작모드가 0:대기이고, 수신가능 상태 1:가능일경우(옵션일듯)
		
		
		if(!StringUtils.equals(gantry.getGantryStatus(), "1")) {
			return "2";
		}
		
		if(!StringUtils.equals(gantry.getGantryOperationMode(), "0")) {
			return "3";
		}
	
		if(StringUtils.equals(gantry.getGantryDataRcvStatus(), "0")) {
			return "4";
		}
		
		
		return "";
		
	}
	
	public static String isCallOUTByLineNo(String lineNo) {
		OrderReportBody orderStatus = getOrder(lineNo);
		
		//1:닫힘, 2:열림
		if(!StringUtils.equals(orderStatus.getDoorStatus(), "1")) {
			return "1";
		}
		
		GantryReportBody gantry = getGantry(lineNo);
		//겐트리 상태가 1:정상이고, 동작모드가 0:대기이고, 수신가능 상태 1:가능일경우(옵션일듯)
		
		
		if(!StringUtils.equals(gantry.getGantryStatus(), "1")) {
			return "2";
		}
		
		if(!StringUtils.equals(gantry.getGantryOperationMode(), "0")) {
			return "3";
		}
	
		if(StringUtils.equals(gantry.getGantryDataRcvStatus(), "0")) {
			return "4";
		}
		
		BufferReportBody getBuffer = getBuffer(lineNo);
		if(!StringUtils.equals(getBuffer.getBufferCellSensingResult(), "0")) {
			return "5";
		}
		
		
		return "";
	}

	
}

