package com.s3s.solutions.eone.manager;

import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.s3s.sfp.settings.accessor.ServerPropertiesAccessor;
import com.s3s.solutions.eone.biz.OrderBizService;
import com.s3s.solutions.eone.biz.OrderGroupBizService;
import com.s3s.solutions.eone.biz.OrderWorkBizService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
@Service
public class OrderManager {

	private final OrderBizService orderBizService;
	private final OrderWorkBizService orderWorkBizService;
	private final OrderGroupBizService orderGroupBizService;
	private final PLCManager plcManager;

	public boolean isRunable() {
		if ("y".equalsIgnoreCase(ServerPropertiesAccessor.getDmwYn())) {
			return true;
		}
		return false;
	}

	@Scheduled(initialDelay = 4000, fixedDelay = 1000) //4300
	public void taskOrder() {
		// TODO KEVIN TEST 시 주석
		if (!isRunable()) {
			return;
		}
		try {
			executeOrder();
		} catch (Exception e) {
			log.error("지시 실행 실패", e);
		}
	}

	public void executeOrder() throws Exception{
		List<OrderVO> orderList = orderBizService.getReadyOrderList();
		for(OrderVO order : orderList) {
			processOrder(order);
		}
	}

	public void processOrder(OrderVO order) throws Exception {
		List<OrderWorkVO> workList = orderWorkBizService.getOrderWorkListByOrder(order);
		boolean isInterfaceFinishOrder = orderGroupBizService.isInterfaceFinishOrder(order, workList);
		if (plcManager.sendPlc(order, workList, isInterfaceFinishOrder)) {
			orderBizService.orderStart(order);
		}
	}
}
