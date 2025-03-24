package com.s3s.solutions.eone.biz;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.sfp.SfpConst;
import com.s3s.sfp.tools.DateTools;
import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.sfp.tools.ListTools;
import com.s3s.solutions.eone.define.EOrderGroupType;
import com.s3s.solutions.eone.define.EOrderKind;
import com.s3s.solutions.eone.define.ERack;
import com.s3s.solutions.eone.define.ETrayStatus;
import com.s3s.solutions.eone.exchange.job.JobService;
import com.s3s.solutions.eone.exchange.job.JobVO;
import com.s3s.solutions.eone.exchange.jobtray.JobTrayService;
import com.s3s.solutions.eone.exchange.jobtray.JobTrayVO;
import com.s3s.solutions.eone.exchange.work.WorkReadTrayVO;
import com.s3s.solutions.eone.exchange.work.WorkService;
import com.s3s.solutions.eone.exchange.work.WorkVO;
import com.s3s.solutions.eone.exchange.work.WorkWriteTrayVO;
import com.s3s.solutions.eone.exchange.workjobtray.WorkJobTrayService;
import com.s3s.solutions.eone.exchange.workjobtray.WorkJobTrayVO;
import com.s3s.solutions.eone.exchange.workjobtray.dto.WorkJobTrayDTO;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayService;
import com.s3s.solutions.eone.service.wmd.workplantray.WorkPlanTrayVO;
import com.s3s.solutions.eone.service.wmd.workplantray.dto.WorkPlanTrayDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class InterfaceBizService {
	private final WorkService workService;
	
	private final JobService jobService;
	
	private final JobTrayService jobTrayService;
	
	private final WorkJobTrayService workJobTrayService;
	
	private final TrayLocationService trayLocationService;
	
	private final WorkPlanTrayBizService workPlanTrayBizService;
	
	private final OrderGroupService orderGroupService;
	
	private final WorkPlanTrayService workPlanTrayService;
	
	//@Transactional(rollbackFor = { Exception.class })
	public void procYudoList() throws Exception {
		//call YUDO_LIST
		WorkVO workVO = workService.procRead();
		if (!ListTools.isNullOrEmpty(workVO.getWorkTrayList())) {
			String interfaceId = GeneratorIDTools.getId("IF");
			
			String rntEntYmd = "";
			rntEntYmd = ListTools.getFirst(workVO.getWorkTrayList()).getEntYmd();
			if (StringUtils.isBlank(rntEntYmd)) {
				rntEntYmd = DateTools.getDateTimeString("yyyyMMdd");
			}
			
			//insert wmd_interface type LIST
			JobVO jobVo = new JobVO();
			jobVo.setIfId(interfaceId);
			jobVo.setIfTypeCd("LIST");
			jobVo.setEntYmd(rntEntYmd);
			jobVo.setReqDt(DateTools.getDateTimeString());
			jobVo.setResult(workVO.getResult());
			jobService.add(jobVo);
			
			List<WorkPlanTrayDTO> insertWorkPlanTrayList = new ArrayList<WorkPlanTrayDTO>();
			List<WorkWriteTrayVO> readTrayList = new ArrayList<WorkWriteTrayVO>();
			String interfacePlanGroupWorkTrayId = GeneratorIDTools.getId("WWPRT");
	
			if (workVO.getWorkTrayList().size() > 0) {
				for(WorkReadTrayVO workReadTrayVO : workVO.getWorkTrayList()) {
					if (StringUtils.isBlank(workReadTrayVO.getEmerYn())) {
						workReadTrayVO.setEmerYn("N");
					}
					
					if (StringUtils.isBlank( workReadTrayVO.getEntYmd())) {
						workReadTrayVO.setEntYmd(DateTools.getDateTimeString("yyyyMMdd"));
					}
					
					String interfaceTrayId = GeneratorIDTools.getId("IFT");
					//insert wmd_interface_tray(List의 읽은 tray)
					JobTrayVO jobTrayVO = new JobTrayVO();
					jobTrayVO.setIfTrayId(interfaceTrayId);
					jobTrayVO.setIfId(interfaceId);
					jobTrayVO.setTrayId(workReadTrayVO.getTargetno());
					jobTrayVO.setInOutTypeCd(workReadTrayVO.getDiv());
					jobTrayVO.setEntYmd(workReadTrayVO.getEntYmd());
					jobTrayVO.setEmergencyYn(workReadTrayVO.getEmerYn());
					jobTrayVO.setSeq(workReadTrayVO.getSeq());
					jobTrayService.add(jobTrayVO);
					
					////YUDO-WORK
					//call YUDO_WORK
					
					//트레이가 있는지 확인
					TrayLocationVO trayLocationVOParam = new TrayLocationVO();
					trayLocationVOParam.setTrayId(workReadTrayVO.getTargetno());
					TrayLocationVO trayLocationVO = trayLocationService.getDetail(trayLocationVOParam);
					
					String rackRemark = "";
					String resultYn = "Y";
					if (workReadTrayVO.getTargetno() != null && workReadTrayVO.getTargetno().length() != 10) {
						resultYn = "N";
						rackRemark = "수신된 랙번호["+workReadTrayVO.getTargetno()+"]가 10자리가 아닙니다.";
					} else if (trayLocationVO == null) {
						resultYn = "N";
						rackRemark = "해당랙이 Shelf에 없습니다.";
					} else {
						List<WorkPlanTrayDTO> dupCheckTrayList = workPlanTrayService.getList(new WorkPlanTrayDTO() {{
							setTrayId(workReadTrayVO.getTargetno());
							setCancelYn(SfpConst.YN_N);
							setExcuteYn(SfpConst.YN_N);
						}});
						if (dupCheckTrayList != null && dupCheckTrayList.size() > 0) {
							resultYn = "N";
							rackRemark = "해당랙이 작업대기 목록에 있습니다.";
						}
					}
					
					WorkWriteTrayVO workWriteTrayVO = new WorkWriteTrayVO();
					workWriteTrayVO.setGb("READ");
					workWriteTrayVO.setEntYmd(workReadTrayVO.getEntYmd());
					workWriteTrayVO.setTargetNo(workReadTrayVO.getTargetno());
					workWriteTrayVO.setResult("Y");
					workWriteTrayVO.setRemark("");
					workWriteTrayVO.setSeq(workReadTrayVO.getSeq());
					String sendRemark = "";
					//중복제거
					if (readTrayList != null && readTrayList.size() > 0) { //중복값 제거
						log.info("size="+readTrayList.stream().filter(wpt -> StringUtils.equals(workReadTrayVO.getTargetno(), wpt.getTargetNo())).collect(Collectors.toList()).size());
						if (readTrayList.stream().filter(wpt -> StringUtils.equals(workReadTrayVO.getTargetno(), wpt.getTargetNo())).collect(Collectors.toList()).size() > 0) {
							continue;
						}
					}
					
					try {
						readTrayList.add(workWriteTrayVO);
						workWriteTrayVO = workService.procWork(workWriteTrayVO);
					} catch (Exception e) {
						workWriteTrayVO.setRtnResult("ERROR");
						if (StringUtils.isNotBlank(rackRemark)) {
							sendRemark = rackRemark + ", 이원 프로시저 에러 :" + e.getMessage();
						} else {
							sendRemark = "이원 프로시저 에러 :" + e.getMessage();
						}
					}
					// reading 처리 끝
					
					// 받은 tray
					//insert wmd_interface
					String readOneIfId = GeneratorIDTools.getId("IF");
					JobVO jobVO = new JobVO();
					jobVO.setIfId(readOneIfId);
					jobVO.setIfTypeCd("WORK");
					jobVO.setEntYmd(workReadTrayVO.getEntYmd());
					jobVO.setReqDt(DateTools.getDateTimeString());
					jobVO.setResult(workWriteTrayVO.getRtnResult());
					jobService.add(jobVO);
					
					//insert wmd_interface_work_tray
					String interfaceWorkTrayId = GeneratorIDTools.getId("IFT");
					
					WorkJobTrayVO workJobTrayVO = new WorkJobTrayVO();
					workJobTrayVO.setIfWorkTrayId(interfaceWorkTrayId);
					workJobTrayVO.setIfId(readOneIfId);
					workJobTrayVO.setRefIfId(interfaceId);
					workJobTrayVO.setTrayId(workReadTrayVO.getTargetno());
					workJobTrayVO.setEmergencyYn(workReadTrayVO.getEmerYn());
					workJobTrayVO.setIfWorkTypeCd("READ");
					workJobTrayVO.setResultYn("Y");
					workJobTrayVO.setEntYmd(workReadTrayVO.getEntYmd());
					workJobTrayVO.setRemark(sendRemark);
					workJobTrayVO.setSeq(workReadTrayVO.getSeq());
					workJobTrayService.add(workJobTrayVO);
					
					if (StringUtils.equals(resultYn, "Y")) {
						//폐기와 호출 분리
						WorkPlanTrayDTO workPlanTrayDTO = new WorkPlanTrayDTO();
						workPlanTrayDTO.setPlanGroupNo(interfacePlanGroupWorkTrayId);
						workPlanTrayDTO.setTrayId(workReadTrayVO.getTargetno());
						if (StringUtils.equals(workReadTrayVO.getDiv(), "1")) { //폐기
							workPlanTrayDTO.setOrderTypeCd(EOrderGroupType.OUTPUT.name());
						} else if (StringUtils.equals(workReadTrayVO.getDiv(), "0")) { //호출
							workPlanTrayDTO.setOrderTypeCd(EOrderGroupType.INQUIRY.name());
						}
						workPlanTrayDTO.setEmergencyYn(workReadTrayVO.getEmerYn());
						//workPlanTrayDTO.setInputDate(DateTools.changeDateString(workReadTrayVO.getEntYmd(), "yyyyMMdd", "yyyy-MM-dd"));
						workPlanTrayDTO.setInputDate(trayLocationVO.getInputDate());
						workPlanTrayDTO.setRackId(trayLocationVO.getRackId());
						workPlanTrayDTO.setRackCellXAxis(trayLocationVO.getRackCellXAxis());
						workPlanTrayDTO.setRackCellYAxis(trayLocationVO.getRackCellYAxis());
						workPlanTrayDTO.setExcuteYn(SfpConst.YN_N);
						workPlanTrayDTO.setTrayStatusCd(ETrayStatus.READY.name());
						workPlanTrayDTO.setRegDt(DateTools.getDateTimeString());
						workPlanTrayDTO.setLineNo(trayLocationVO.getLineNo());
						workPlanTrayDTO.setCancelYn(SfpConst.YN_N);
						workPlanTrayDTO.setOrderKindCd(EOrderKind.INTERFACE.name());
						workPlanTrayDTO.setIfWorkTrayId(interfaceWorkTrayId);
						workPlanTrayDTO.setRefIfId(interfaceId);
						insertWorkPlanTrayList.add(workPlanTrayDTO);
					} else {
						workWriteTrayVO = new WorkWriteTrayVO();
						workWriteTrayVO.setGb(workReadTrayVO.getDiv());
						workWriteTrayVO.setEntYmd(workReadTrayVO.getEntYmd());
						workWriteTrayVO.setTargetNo(workReadTrayVO.getTargetno());
						workWriteTrayVO.setResult(resultYn);
						workWriteTrayVO.setRemark(rackRemark);
						workWriteTrayVO.setSeq(workReadTrayVO.getSeq());
						
						try {
							log.info("workWriteTrayVO="+workWriteTrayVO.getDiv());
							workWriteTrayVO = workService.procWork(workWriteTrayVO);
						} catch (Exception e) {
							workWriteTrayVO.setRtnResult("ERROR");
							if (StringUtils.isNotBlank(rackRemark)) {
								rackRemark = rackRemark + ", 이원 프로시저 에러 :" + e.getMessage();
							} else {
								rackRemark = "이원 프로시저 에러 :" + e.getMessage();
							}
						}
						
						//insert wmd_interface
						readOneIfId = GeneratorIDTools.getId("IF");
						jobVO = new JobVO();
						jobVO.setIfId(readOneIfId);
						jobVO.setIfTypeCd("WORK");
						jobVO.setEntYmd(workReadTrayVO.getEntYmd());
						jobVO.setReqDt(DateTools.getDateTimeString());
						jobVO.setResult(workWriteTrayVO.getRtnResult());
						jobService.add(jobVO);
						
						String gb = "";
						if (StringUtils.equals(workReadTrayVO.getDiv(), "0")) {
							gb = "OUT";
						} else if (StringUtils.equals(workReadTrayVO.getDiv(), "1")) {
							gb = "DEL";
						} else {
							gb = "ELSE";
						}
						
						interfaceWorkTrayId = GeneratorIDTools.getId("IFT");
						workJobTrayVO = new WorkJobTrayVO();
						workJobTrayVO.setIfWorkTrayId(interfaceWorkTrayId);
						workJobTrayVO.setIfId(readOneIfId);
						workJobTrayVO.setRefIfId(interfaceId);
						workJobTrayVO.setTrayId(workReadTrayVO.getTargetno());
						workJobTrayVO.setEmergencyYn(workReadTrayVO.getEmerYn());
						workJobTrayVO.setIfWorkTypeCd(gb);
						workJobTrayVO.setResultYn(resultYn);
						workJobTrayVO.setEntYmd(workReadTrayVO.getEntYmd());
						workJobTrayVO.setRemark(rackRemark);
						workJobTrayVO.setSeq(workReadTrayVO.getSeq());
						workJobTrayService.add(workJobTrayVO);
					}
				}
				//insert wmd_work_plan_tray
				workPlanTrayService.registerGroupTrayList(insertWorkPlanTrayList);
			}
		}
	}
	
	public void procYudoWork(OrderWorkVO work) throws Exception {
		OrderGroupVO orderGroup = orderGroupService.getGroupByOrderId(work.getOrderId());
		
		if (orderGroup != null) {
			String gb = "IN";
			String resultYn = "Y";
			String remark = "";
			
			WorkJobTrayVO seqWorkJobTrayVO = new WorkJobTrayVO();
			String seq = "0";
			
			if (StringUtils.equals(orderGroup.getOrderGroupTypeCd(), EOrderGroupType.INPUT.name())) {
				gb = "IN";
				if (StringUtils.isBlank(work.getTrayId())) {
					resultYn = "N";
					remark = "Rack번호 미인식";
				}
			} else {
				if (StringUtils.equals(orderGroup.getOrderGroupTypeCd(), EOrderGroupType.OUTPUT.name())) {
					gb = "DEL";
				} else if (StringUtils.equals(orderGroup.getOrderGroupTypeCd(), EOrderGroupType.INQUIRY.name())) {
					gb = "OUT";
				}
				seqWorkJobTrayVO = workJobTrayService.getDetailByPlanNo(new WorkJobTrayVO() {{
					setPlanNo(work.getPlanNo());
				}});
				//없을 경우(수기 등록)
				if (seqWorkJobTrayVO != null) {
					seq = seqWorkJobTrayVO.getSeq();
				}
				
			}
			Integer eoneShelf = Integer.parseInt(ERack.valueOf(work.getRackId()).getCode());
			eoneShelf = eoneShelf % 2;
			if (eoneShelf == 0) {
				eoneShelf = 2;
			}
			
			WorkWriteTrayVO workWriteTrayVO = new WorkWriteTrayVO();
			workWriteTrayVO.setGb(gb);
			workWriteTrayVO.setEntYmd(DateTools.getDateTimeString("yyyyMMdd"));
			workWriteTrayVO.setTargetNo(work.getTrayId());
			workWriteTrayVO.setResult(resultYn);
			workWriteTrayVO.setRemark(remark);
			workWriteTrayVO.setLineNo(orderGroup.getLineNo());
			workWriteTrayVO.setRackNo(eoneShelf.toString());
			workWriteTrayVO.setColume(work.getRackCellXAxis().toString());
			workWriteTrayVO.setFloor(work.getRackCellYAxis().toString());
			workWriteTrayVO.setSeq(seq);
			try {
				log.info("workWriteTrayVO="+workWriteTrayVO.getDiv());
				workWriteTrayVO = workService.procWork(workWriteTrayVO);
			} catch (Exception e) {
				//이원 프로시저 에러 발생시 처리
				workWriteTrayVO.setRtnResult("ERROR");
				resultYn = "N";
				if (StringUtils.isNotBlank(remark)) {
					remark = remark + ", 이원 프로시저 에러 :" + e.getMessage();
				} else {
					remark = "이원 프로시저 에러 :" + e.getMessage();
				}
			}
			
			String IfId = GeneratorIDTools.getId("IF");
			JobVO jobVo = new JobVO();
			jobVo.setIfId(IfId);
			jobVo.setIfTypeCd("WORK");
			jobVo.setEntYmd(workWriteTrayVO.getEntYmd());
			jobVo.setReqDt(DateTools.getDateTimeString());
			jobVo.setResult(workWriteTrayVO.getRtnResult());
			jobService.add(jobVo);

			//insert wmd_interface_work_tray
			String interfaceWorkTrayId = GeneratorIDTools.getId("IFT");
			WorkJobTrayVO workJobTrayVO = new WorkJobTrayVO();
			workJobTrayVO.setIfWorkTrayId(interfaceWorkTrayId);
			workJobTrayVO.setIfId(IfId);
			workJobTrayVO.setRefIfId(null);
			workJobTrayVO.setTrayId(work.getTrayId());
			workJobTrayVO.setIfWorkTypeCd(workWriteTrayVO.getGb());
			workJobTrayVO.setResultYn(resultYn);
			workJobTrayVO.setEmergencyYn(orderGroup.getEmergencyYn());
			workJobTrayVO.setLineNo(orderGroup.getLineNo());
			workJobTrayVO.setRackId(work.getRackId());
			workJobTrayVO.setRackCellXAxis(work.getRackCellXAxis());
			workJobTrayVO.setRackCellYAxis(work.getRackCellYAxis());
			workJobTrayVO.setEntYmd(workWriteTrayVO.getEntYmd());
			workJobTrayVO.setRemark(remark);
			workJobTrayVO.setSeq(seq);
			workJobTrayService.add(workJobTrayVO);
		}
	}
	
	/**
	 * 연속 업무 실행시 랙이 없을 경우 호출
	 * @param workPlanTrayVO
	 * @param remark
	 * @throws Exception
	 */
	public void procYudoWork(WorkPlanTrayVO workPlanTrayVO, String remark) throws Exception {
		
		String gb = "IN";
		WorkJobTrayVO seqWorkJobTrayVO = new WorkJobTrayVO();
		String seq = "0";
		
		if (StringUtils.equals(workPlanTrayVO.getOrderTypeCd(), EOrderGroupType.OUTPUT.name()) || StringUtils.equals(workPlanTrayVO.getOrderTypeCd(), EOrderGroupType.INQUIRY.name()) ) {
			
			seqWorkJobTrayVO = workJobTrayService.getDetailByPlanNo(new WorkJobTrayVO() {{
				setPlanNo(workPlanTrayVO.getPlanNo());
			}});
			
			//없을 경우(수기 등록)
			if (seqWorkJobTrayVO != null) {
				seq = seqWorkJobTrayVO.getSeq();
			}
			
			if (StringUtils.equals(workPlanTrayVO.getOrderTypeCd(), EOrderGroupType.OUTPUT.name())) {
				gb = "DEL";
			} else if (StringUtils.equals(workPlanTrayVO.getOrderTypeCd(), EOrderGroupType.INQUIRY.name())) {
				gb = "OUT";
			}
		}
		
		
		Integer eoneShelf = Integer.parseInt(ERack.valueOf(workPlanTrayVO.getRackId()).getCode());
		eoneShelf = eoneShelf % 2;
		if (eoneShelf == 0) {
			eoneShelf = 2;
		}
		//
		WorkWriteTrayVO workWriteTrayVO = new WorkWriteTrayVO();
		workWriteTrayVO.setGb(gb);
		workWriteTrayVO.setEntYmd(DateTools.getDateTimeString("yyyyMMdd"));
		workWriteTrayVO.setTargetNo(workPlanTrayVO.getTrayId());
		workWriteTrayVO.setResult(SfpConst.YN_N);
		workWriteTrayVO.setRemark(remark);
		workWriteTrayVO.setLineNo(workPlanTrayVO.getLineNo());
		workWriteTrayVO.setRackNo(eoneShelf.toString());
		workWriteTrayVO.setColume(workPlanTrayVO.getRackCellXAxis().toString());
		workWriteTrayVO.setFloor(workPlanTrayVO.getRackCellYAxis().toString());
		workWriteTrayVO.setSeq(seq);
		String resultYn = "Y";
		try {
			log.info("workWriteTrayVO="+workWriteTrayVO.getDiv());
			workWriteTrayVO = workService.procWork(workWriteTrayVO);
		} catch (Exception e) {
			//이원 프로시저 에러 발생시 처리
			workWriteTrayVO.setRtnResult("ERROR");
			resultYn = "N";
			if (StringUtils.isNotBlank(remark)) {
				remark = remark + ", 이원 프로시저 에러 :" + e.getMessage();
			} else {
				remark = "이원 프로시저 에러 :" + e.getMessage();
			}
		}
		
		String IfId = GeneratorIDTools.getId("IF");
		JobVO jobVo = new JobVO();
		jobVo.setIfId(IfId);
		jobVo.setIfTypeCd("WORK");
		jobVo.setEntYmd(workWriteTrayVO.getEntYmd());
		jobVo.setReqDt(DateTools.getDateTimeString());
		jobVo.setResult(workWriteTrayVO.getRtnResult());
		jobService.add(jobVo);
		
		//insert wmd_interface_work_tray
		String interfaceWorkTrayId = GeneratorIDTools.getId("IFT");
		WorkJobTrayVO workJobTrayVO = new WorkJobTrayVO();
		workJobTrayVO.setIfWorkTrayId(interfaceWorkTrayId);
		workJobTrayVO.setIfId(IfId);
		workJobTrayVO.setRefIfId(null);
		workJobTrayVO.setTrayId(workPlanTrayVO.getTrayId());
		workJobTrayVO.setIfWorkTypeCd(workWriteTrayVO.getGb());
		workJobTrayVO.setResultYn(resultYn);
		workJobTrayVO.setEmergencyYn(workPlanTrayVO.getEmergencyYn());
		workJobTrayVO.setLineNo(workPlanTrayVO.getLineNo());
		workJobTrayVO.setRackId(workPlanTrayVO.getRackId());
		workJobTrayVO.setRackCellXAxis(workPlanTrayVO.getRackCellXAxis());
		workJobTrayVO.setRackCellYAxis(workPlanTrayVO.getRackCellYAxis());
		workJobTrayVO.setEntYmd(workWriteTrayVO.getEntYmd());
		workJobTrayVO.setRemark(remark);
		workJobTrayVO.setSeq(seq);
		workJobTrayService.add(workJobTrayVO);
	}
}
