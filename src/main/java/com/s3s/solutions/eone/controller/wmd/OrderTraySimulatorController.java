package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.tools.GeneratorIDTools;
import com.s3s.solutions.eone.biz.OrderTrayBizService;
import com.s3s.solutions.eone.define.EOrderType;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시별 트레이 정보")
@RequestMapping(value = "/solutions/eone/wmd/ordertraysimulator")
public class OrderTraySimulatorController {

	private final OrderTrayBizService orderTrayBizService;

	@RequestMapping(value = "/generateOutputOrderTraySimulator", method = { RequestMethod.GET, RequestMethod.POST })
	public List<OrderTrayVO> generateOutputOrderTraySimulator() throws Exception {
//		String orderId = GeneratorIDTools.getId("WO");
		String orderId = GeneratorIDTools.getId("");
		return orderTrayBizService.generateOuputOrderTray(orderId, EOrderType.OUTPUT);
	}

	@RequestMapping(value = "/generateInquiryOutputOrderTraySimulator", method = { RequestMethod.GET, RequestMethod.POST })
	public List<OrderTrayVO> generateInquiryOutputOrderTraySimulator() throws Exception {
//		String orderId = GeneratorIDTools.getId("WO");
		String orderId = GeneratorIDTools.getId("");
		return orderTrayBizService.generateOuputOrderTray(orderId, EOrderType.INQUIRY);
	}

	@RequestMapping(value = "/generateInputOrderTraySimulator", method = { RequestMethod.GET, RequestMethod.POST })
	public List<OrderTrayVO> generateInputOrderTraySimulator(@RequestBody List<OrderTrayVO> list) throws Exception {
//		String orderId = GeneratorIDTools.getId("WO");
		String orderId = GeneratorIDTools.getId("");
		return orderTrayBizService.generateInputOrderTray(orderId, list);
	}

}