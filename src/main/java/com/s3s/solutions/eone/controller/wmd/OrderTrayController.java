package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayService;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.ordertray.dto.OrderTrayDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시별 트레이 정보")
@RequestMapping(value = "/solutions/eone/wmd/ordertray")
public class OrderTrayController {

	private final OrderTrayService orderTrayService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderTrayDTO> getPagingList(OrderTrayDTO vo, PagingDTO page) throws Exception {
		return orderTrayService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<OrderTrayDTO> getList(OrderTrayDTO vo) throws Exception {
		return orderTrayService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(OrderTrayDTO vo) throws Exception {
		orderTrayService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(OrderTrayDTO vo) throws Exception {
		orderTrayService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(OrderTrayDTO vo) throws Exception {
		orderTrayService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<OrderTrayDTO> list) throws Exception {
		orderTrayService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<OrderTrayDTO> list) throws Exception {
		orderTrayService.deleteList(list);
	}
	
	/**
	 * new Tray 중복 체크
	 * @param list
	 * @throws Exception
	 */
	@RequestMapping(value = "/dulipCheck", method = { RequestMethod.GET, RequestMethod.POST })
	public void duplicateTrayId(@RequestParam(value="trayId",defaultValue = "") String trayId) throws Exception {
		orderTrayService.duplicateTrayId(trayId);
	}

}