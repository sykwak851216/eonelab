package com.s3s.solutions.eone.service.wmd.test;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.IntStream;

import javax.annotation.PostConstruct;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.define.EOrderStatus;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.dmw.command.PLCCommand;
import com.s3s.solutions.eone.dmw.command.message.body.BufferReportBody;
import com.s3s.solutions.eone.dmw.command.message.body.GantryReportBody;
import com.s3s.solutions.eone.dmw.command.message.body.OrderReportBody;
import com.s3s.solutions.eone.dmw.command.message.body.OrderRequestBody;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Service
@Slf4j
public class TestService {
	/*
	private static GantryReportBody gantry;
	private static OrderReportBody orderRes;
	private static OrderRequestBody orderReq;
	private static BufferReportBody buffer;
	private final PLCCommand commad;
	private AtomicInteger delay = new AtomicInteger();
	private AtomicInteger move_cnt = new AtomicInteger();

	public static void setOrder(OrderRequestBody order) {
		orderReq = order;
	}
	@PostConstruct
	public void init() {
		buffer = new BufferReportBody();
		buffer.setBufferOperationMode("0");
		buffer.setBufferPreLocation("0");
		buffer.setBufferTargetLocation("0");
		Map<String, String> bufferCellStatus = new HashMap<>();
		IntStream.range(1, 9).forEach(i -> {
			bufferCellStatus.put(String.valueOf(i), EoneConst.BOX_OFF);
		});
		buffer.setBufferCellStatus(bufferCellStatus);
		gantry = new GantryReportBody();
//		gantry.setGantryStatus1("1");
//		gantry.setGantryStatus2("1");
//		gantry.setGantryStatus3("1");
//		gantry.setGantryOperationMode1("0");
//		gantry.setGantryOperationMode2("0");
//		gantry.setGantryOperationMode3("0");
	}

//	@Scheduled(fixedDelay = 2000)
	public void exec() throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		if (orderReq != null) {
			if (orderRes == null) {
				orderRes = new OrderReportBody();
				//orderRes.setOrderNo(orderReq.getOrderNo());
				orderRes.setOrderProcStatus(EOrderStatus.READY.getCode());
				Map<String, String> bufferCellStatus = new HashMap<>();
				IntStream.range(1, 9).forEach(i -> {
					bufferCellStatus.put(String.valueOf(i), "0");
				});
				//orderRes.setOrderTrayProcStatus(bufferCellStatus);
			} else if (StringUtils.equals(orderRes.getOrderProcStatus(), EOrderStatus.READY.getCode())) {
				orderRes.setOrderProcStatus(EOrderStatus.ING.getCode());
			} else if (StringUtils.equals(orderRes.getOrderProcStatus(), EOrderStatus.ING.getCode())) {
				//if (processBuffer(orderReq.getOrderType())) {
					orderRes.setOrderProcStatus(EOrderStatus.COMPLETE.getCode());
					buffer.setBufferOperationMode("1");
					buffer.setBufferPreLocation(buffer.getBufferTargetLocation());
					buffer.setBufferTargetLocation("0");
				}
			}
			//commad.getOrderReport(orderRes);
			if (StringUtils.equals(orderRes.getOrderProcStatus(), EOrderStatus.COMPLETE.getCode())) {
				orderRes = null;
				orderReq = null;
			}
		}
	}

	private boolean processBuffer(String orderType)
			throws IllegalAccessException, InvocationTargetException, NoSuchMethodException {
		for (int i = 1; i <= 8; i++) {
			String rack = String.valueOf(PropertyUtils.getProperty(orderReq, "orderProcBufferRack" + i));
			String targetRack = String.valueOf(PropertyUtils.getProperty(orderRes, "orderProcBufferRack" + i));
			if (!"null".equals(rack) && "null".equals(targetRack)) {
				if (StringUtils.equals(buffer.getBufferOperationMode(), "2")
						&& StringUtils.equals(buffer.getBufferTargetLocation(), rack)) {
					if (delay.getAndIncrement() == 5) {
						PropertyUtils.setProperty(orderRes, "orderProcBufferRack" + i,
								PropertyUtils.getProperty(orderReq, "orderProcBufferRack" + i));
						PropertyUtils.setProperty(orderRes, "orderProcBufferX" + i,
								PropertyUtils.getProperty(orderReq, "orderProcBufferX" + i));
						PropertyUtils.setProperty(orderRes, "orderProcBufferY" + i,
								PropertyUtils.getProperty(orderReq, "orderProcBufferY" + i));
						//orderRes.getOrderTrayProcStatus().put(String.valueOf(i), "3");
						buffer.getBufferCellStatus().put(String.valueOf(i),
								StringUtils.equals(EOrderType.INPUT.getCode(), orderType) ? EoneConst.BOX_OFF : EoneConst.BOX_ON);
						delay.set(0);
					}
				} else if (StringUtils.equals(buffer.getBufferOperationMode(), "2")
						&& !StringUtils.equals(buffer.getBufferTargetLocation(), rack)) {
					buffer.setBufferOperationMode("1");
					buffer.setBufferPreLocation(buffer.getBufferTargetLocation());
					buffer.setBufferTargetLocation(rack);
				}
				return false;
			}
		}
		return true;
	}

//	@Scheduled(fixedDelay = 3000)
	public void move() {
		if (StringUtils.equals("0", buffer.getBufferOperationMode())) {
			buffer.setBufferOperationMode("1");
		} else if (StringUtils.equals("1", buffer.getBufferOperationMode())) {
			if (10 == move_cnt.getAndIncrement()) {
				buffer.setBufferOperationMode("2");
				move_cnt.set(0);
			}
		}
		//commad.getBufferReport(buffer);
	}

	public void modifyBuffers(String sensor, String onOff) {
		buffer.getBufferCellStatus().put(sensor, onOff);
		//commad.getBufferReport(buffer);
	}
	*/
}