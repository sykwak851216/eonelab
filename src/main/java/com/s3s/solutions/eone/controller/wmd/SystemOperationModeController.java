package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.systemoperationmode.SystemOperationModeService;
import com.s3s.solutions.eone.service.wmd.systemoperationmode.dto.SystemOperationModeDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("시스템 동작 모드")
@RequestMapping(value = "/solutions/eone/wmd/systemoperationmode")
public class SystemOperationModeController {

	private final SystemOperationModeService systemOperationModeService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<SystemOperationModeDTO> getPagingList(SystemOperationModeDTO vo, PagingDTO page) throws Exception {
		return systemOperationModeService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<SystemOperationModeDTO> getList(SystemOperationModeDTO vo) throws Exception {
		return systemOperationModeService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(SystemOperationModeDTO vo) throws Exception {
		systemOperationModeService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(SystemOperationModeDTO vo) throws Exception {
		systemOperationModeService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(SystemOperationModeDTO vo) throws Exception {
		systemOperationModeService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<SystemOperationModeDTO> list) throws Exception {
		systemOperationModeService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<SystemOperationModeDTO> list) throws Exception {
		systemOperationModeService.deleteList(list);
	}

}