package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.biz.OrderWorkBizService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkService;
import com.s3s.solutions.eone.service.wmd.orderwork.OrderWorkVO;
import com.s3s.solutions.eone.service.wmd.orderwork.dto.OrderWorkDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시별 작업 내역")
@RequestMapping(value = "/solutions/eone/wmd/orderwork")
public class OrderWorkController {

	private final OrderWorkService orderWorkService;

	private final OrderWorkBizService orderWorkBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderWorkDTO> getPagingList(OrderWorkDTO vo, PagingDTO page) throws Exception {
		return orderWorkService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<OrderWorkDTO> getList(OrderWorkDTO vo) throws Exception {
		return orderWorkService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(OrderWorkDTO vo) throws Exception {
		orderWorkService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(OrderWorkDTO vo) throws Exception {
		orderWorkService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(OrderWorkDTO vo) throws Exception {
		orderWorkService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<OrderWorkDTO> list) throws Exception {
		orderWorkService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<OrderWorkDTO> list) throws Exception {
		orderWorkService.deleteList(list);
	}

	@RequestMapping(value = "/getOrderWorkListByOrderGroupId", method = { RequestMethod.GET, RequestMethod.POST })
	public List<OrderWorkVO> getOrderWorkListByOrderGroupId(OrderVO orderVO) throws Exception {
		return orderWorkBizService.getOrderWorkListByOrderGroupId(orderVO);
	}

	@RequestMapping(value = "/getOrderWorkHistoryListByOrderGroupId", method = { RequestMethod.GET, RequestMethod.POST })
	public List<OrderWorkVO> getOrderWorkHistoryListByOrderGroupId(OrderVO orderVO) throws Exception {
		return orderWorkBizService.getOrderWorkHistoryListByOrderGroupId(orderVO);
	}

}