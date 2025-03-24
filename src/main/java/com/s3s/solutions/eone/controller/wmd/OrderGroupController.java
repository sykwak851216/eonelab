package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;
import com.s3s.solutions.eone.biz.OrderGroupBizService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupService;
import com.s3s.solutions.eone.service.wmd.ordergroup.OrderGroupVO;
import com.s3s.solutions.eone.service.wmd.ordergroup.dto.OrderGroupDTO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("지시그룹")
@RequestMapping(value = "/solutions/eone/wmd/ordergroup")
public class OrderGroupController {

	private final OrderGroupService orderGroupService;

	private final OrderGroupBizService orderGroupBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<OrderGroupVO> getPagingList(OrderGroupVO vo, PagingDTO page) throws Exception {
		return orderGroupService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<OrderGroupVO> getList(OrderGroupVO vo) throws Exception {
		return orderGroupService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(OrderGroupDTO vo) throws Exception {
		orderGroupService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(OrderGroupDTO vo) throws Exception {
		orderGroupService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(OrderGroupDTO vo) throws Exception {
		orderGroupService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<OrderGroupDTO> list) throws Exception {
		orderGroupService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<OrderGroupDTO> list) throws Exception {
		orderGroupService.deleteList(list);
	}

	/**
	 * 보관처리
	 * @param list
	 * @throws Exception
	 */
	@RequestMapping(value = "/generateInputOrderGroup", method = { RequestMethod.GET, RequestMethod.POST })
	public void generateInputOrder(@RequestBody List<OrderTrayVO> list) throws Exception {
		orderGroupBizService.generateInputOrderGroup(list);
	}
	
	/**
	 * new 라인별 보관업무
	 * @param list
	 * @throws Exception
	 */
	@RequestMapping(value = "/generateInputOrderGroupByLineNo", method = { RequestMethod.GET, RequestMethod.POST })
	public void generateInputOrderGroupByLineNo(@RequestBody List<OrderTrayVO> list) throws Exception {
		orderGroupBizService.generateInputOrderGroupByLineNo(list);
	}
	
	/**
	 * 연속 지시 시작
	 * @param lineNo
	 * @throws Exception
	 */
	@RequestMapping(value = "/continuousOrderByLineNo", method = { RequestMethod.GET, RequestMethod.POST })
	public void continuousOrderByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		orderGroupBizService.continuousOrderByLineNo(lineNo);
	}


}