package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.SystemOperationModeStepService;
import com.s3s.solutions.eone.service.wmd.systemoperationmodestep.dto.SystemOperationModeStepDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("시스템 동작 모드 단계")
@RequestMapping(value = "/solutions/eone/wmd/systemoperationmodestep")
public class SystemOperationModeStepController {

	private final SystemOperationModeStepService systemOperationModeStepService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<SystemOperationModeStepDTO> getPagingList(SystemOperationModeStepDTO vo, PagingDTO page) throws Exception {
		return systemOperationModeStepService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<SystemOperationModeStepDTO> getList(SystemOperationModeStepDTO vo) throws Exception {
		return systemOperationModeStepService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(SystemOperationModeStepDTO vo) throws Exception {
		systemOperationModeStepService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(SystemOperationModeStepDTO vo) throws Exception {
		systemOperationModeStepService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(SystemOperationModeStepDTO vo) throws Exception {
		systemOperationModeStepService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<SystemOperationModeStepDTO> list) throws Exception {
		systemOperationModeStepService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<SystemOperationModeStepDTO> list) throws Exception {
		systemOperationModeStepService.deleteList(list);
	}

}