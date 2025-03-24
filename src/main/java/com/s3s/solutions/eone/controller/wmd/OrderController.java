package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.biz.OrderBizService;
import com.s3s.solutions.eone.service.wmd.order.OrderService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.order.dto.OrderDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시")
@RequestMapping(value = "/solutions/eone/wmd/order")
public class OrderController {

	private final OrderService orderService;

	private final OrderBizService orderBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderVO> getPagingList(OrderVO vo, PagingDTO page) throws Exception {
		return orderService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<OrderVO> getList(OrderVO vo) throws Exception {
		return orderService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(OrderDTO vo) throws Exception {
		orderService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(OrderDTO vo) throws Exception {
		orderService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(OrderDTO vo) throws Exception {
		orderService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<OrderDTO> list) throws Exception {
		orderService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<OrderDTO> list) throws Exception {
		orderService.deleteList(list);
	}
	
	/**
	 * 보관 - 미인식 바코드 업무진행상태 체크 및 수정
	 * @param orderVO
	 * @throws Exception
	 */
	@RequestMapping(value = { "/changeOperationDischargeInputOrderTray" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void changeOperationDischargeInputOrderTray(@RequestBody OrderVO orderVO) throws Exception {
		orderBizService.changeOperationDischargeInputOrderTray(orderVO);
	}

	/**
	 * 보관 - 미인식 바코드 처리
	 * @param orderVO
	 * @throws Exception
	 */
	@RequestMapping(value = { "/dischargeInputOrderTray" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void dischargeInputOrderTray(@RequestBody OrderVO orderVO) throws Exception {
		orderBizService.dischargeInputOrderTray(orderVO);
	}
	
	/**
	 * 폐기업무 - 트레이 배출
	 * @param orderVO
	 * @throws Exception
	 */
	@RequestMapping(value = { "/dischargeOutputOrderTray" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void dischargeOutputOrderTray(@RequestBody OrderVO orderVO) throws Exception {
		orderBizService.dischargeOutputOrderTray(orderVO);
	}

	@RequestMapping(value = { "/dischargeInquiryOutputOrderTray" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void dischargeInquiryOutputOrderTray(@RequestBody OrderVO orderVO) throws Exception {
		orderBizService.dischargeInquiryOutputOrderTray(orderVO);
	}

	/**
	 * 호출 업무 - 트레이 확인완료
	 * @param orderVO
	 * @throws Exception
	 */
	@RequestMapping(value = { "/completeInquiryOutputOrderTray" }, method = { RequestMethod.POST, RequestMethod.GET })
	public void completeInquiryOutputOrderTray(@RequestBody OrderVO orderVO) throws Exception {
		orderBizService.completeInquiryOutputOrderTray(orderVO);
	}

}