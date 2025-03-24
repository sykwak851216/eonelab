package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryService;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.OrderOperationHistoryVO;
import com.s3s.solutions.eone.service.wmd.orderoperationhistory.dto.OrderOperationHistoryDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시별 동작 히스토리")
@RequestMapping(value = "/solutions/eone/wmd/orderoperationhistory")
public class OrderOperationHistoryController {

	private final OrderOperationHistoryService orderOperationHistoryService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderOperationHistoryDTO> getPagingList(OrderOperationHistoryDTO vo, PagingDTO page) throws Exception {
		return orderOperationHistoryService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getOrderOperationHistoryPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderOperationHistoryVO> getOrderOperationHistoryPagingList(OrderOperationHistoryVO vo, PagingDTO page) throws Exception {
		return orderOperationHistoryService.getOrderOperationHistoryPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<OrderOperationHistoryDTO> getList(OrderOperationHistoryDTO vo) throws Exception {
		return orderOperationHistoryService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(OrderOperationHistoryDTO vo) throws Exception {
		orderOperationHistoryService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(OrderOperationHistoryDTO vo) throws Exception {
		orderOperationHistoryService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(OrderOperationHistoryDTO vo) throws Exception {
		orderOperationHistoryService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<OrderOperationHistoryDTO> list) throws Exception {
		orderOperationHistoryService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<OrderOperationHistoryDTO> list) throws Exception {
		orderOperationHistoryService.deleteList(list);
	}

}