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
import com.s3s.solutions.eone.biz.TrayLocationBizService;
import com.s3s.solutions.eone.service.wmd.order.OrderVO;
import com.s3s.solutions.eone.service.wmd.ordertray.OrderTrayVO;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationService;
import com.s3s.solutions.eone.service.wmd.traylocation.TrayLocationVO;
import com.s3s.solutions.eone.service.wmd.traylocation.dto.TrayLocationDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("트레이 위치")
@RequestMapping(value = "/solutions/eone/wmd/traylocation")
public class TrayLocationController {

	private final TrayLocationService trayLocationService;

	private final TrayLocationBizService trayLocationBizService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<TrayLocationVO> getPagingList(TrayLocationVO vo, PagingDTO page) throws Exception {
		return trayLocationService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getList(TrayLocationVO vo) throws Exception {
		return trayLocationService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(TrayLocationDTO vo) throws Exception {
		trayLocationService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(TrayLocationDTO vo) throws Exception {
		trayLocationService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(TrayLocationDTO vo) throws Exception {
		trayLocationService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<TrayLocationDTO> list) throws Exception {
		trayLocationService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<TrayLocationDTO> list) throws Exception {
		trayLocationService.deleteList(list);
	}

	@RequestMapping(value = { "/getTrayLocation" }, method = { RequestMethod.POST, RequestMethod.GET })
	public TrayLocationVO getTrayLocation(TrayLocationVO vo) throws Exception {
		return trayLocationService.getDetail(vo);
	}

	@RequestMapping(value = { "/getTrayLocationPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<TrayLocationVO> getTrayLocationPagingList(TrayLocationVO vo, PagingDTO page) throws Exception {
		return trayLocationService.getTrayLocationPagingList(vo, page);
	}

	@RequestMapping(value = { "/getTrayLocationList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getTrayLocationList(@RequestBody TrayLocationVO vo) throws Exception {
		return trayLocationService.getTrayLocationList(vo);
	}

	/*
	@RequestMapping(value = { "/getBufferTrayLocationListIncludeSensor" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensor() throws Exception {
		return trayLocationBizService.getBufferTrayLocationListIncludeSensor();
	}
	*/

	@RequestMapping(value = { "/getBufferTrayLocationListIncludeSensor" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensor(String lineNo) throws Exception {
		return trayLocationBizService.getBufferTrayLocationListIncludeSensorByLineNo(lineNo);
	}

	/*
	@RequestMapping(value = { "/getBufferTrayLocationListIncludeSensorAndInqueryQty" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensorAndInqueryQty(OrderVO orderVO) throws Exception {
		return trayLocationBizService.getBufferTrayLocationListIncludeSensorAndInqueryQty(orderVO);
	}
	*/

	/**
	 * 반출, 호출(반출)에서 호출됨
	 * @param orderVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "/getBufferTrayLocationListIncludeSensorAndInqueryQtyByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getBufferTrayLocationListIncludeSensorAndInqueryQtyByLineNo(OrderVO orderVO) throws Exception {
		return trayLocationBizService.getBufferTrayLocationListIncludeSensorAndInqueryQtyByLineNo(orderVO);
	}

	/**
	 * 호출업무에서 호출됨
	 * 메인화면의 랙현황에서 호출됨
	 * @param vo
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = { "/getRackInTrayList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getRackInTrayList(TrayLocationVO vo) throws Exception {
		return trayLocationService.getRackInTrayList(vo);
	}

	@RequestMapping(value = { "/getRackEmptyCellList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getRackEmptyCellList() throws Exception {
		return trayLocationService.getRackEmptyCellList();
	}

	@RequestMapping(value = { "/getRackEmptyCellListByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> getRackEmptyCellListByLineNo(@RequestParam(value="lineNo",defaultValue = "") String lineNo) throws Exception {
		return trayLocationService.getRackEmptyCellListByLineNo(lineNo);
	}

	@RequestMapping(value = { "/generateInputTrayLocationByLineNo" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationVO> generateInputTrayLocationByLineNo(@RequestBody List<OrderTrayVO> list) throws Exception {
		return trayLocationBizService.generateInputTrayLocationByLineNo(list);
	}

	@RequestMapping(value = { "/duplicationCheckTrayId" }, method = { RequestMethod.POST, RequestMethod.GET })
	public boolean duplicationCheckTrayId(TrayLocationVO vo) throws Exception {
		return trayLocationBizService.duplicationCheckTrayId(vo.getTrayId());
	}

}