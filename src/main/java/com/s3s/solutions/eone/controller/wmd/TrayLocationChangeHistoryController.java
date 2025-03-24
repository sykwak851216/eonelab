package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.TrayLocationChangeHistoryService;
import com.s3s.solutions.eone.service.wmd.traylocationchangehistory.dto.TrayLocationChangeHistoryDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("트레이 위치 변경 이력")
@RequestMapping(value = "/solutions/eone/wmd/traylocationchangehistory")
public class TrayLocationChangeHistoryController {

	private final TrayLocationChangeHistoryService trayLocationChangeHistoryService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<TrayLocationChangeHistoryDTO> getPagingList(TrayLocationChangeHistoryDTO vo, PagingDTO page) throws Exception {
		return trayLocationChangeHistoryService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<TrayLocationChangeHistoryDTO> getList(TrayLocationChangeHistoryDTO vo) throws Exception {
		return trayLocationChangeHistoryService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(TrayLocationChangeHistoryDTO vo) throws Exception {
		trayLocationChangeHistoryService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(TrayLocationChangeHistoryDTO vo) throws Exception {
		trayLocationChangeHistoryService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(TrayLocationChangeHistoryDTO vo) throws Exception {
		trayLocationChangeHistoryService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<TrayLocationChangeHistoryDTO> list) throws Exception {
		trayLocationChangeHistoryService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<TrayLocationChangeHistoryDTO> list) throws Exception {
		trayLocationChangeHistoryService.deleteList(list);
	}

}