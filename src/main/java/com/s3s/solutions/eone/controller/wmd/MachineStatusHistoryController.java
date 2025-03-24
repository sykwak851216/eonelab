package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.machinestatushistory.MachineStatusHistoryService;
import com.s3s.solutions.eone.service.wmd.machinestatushistory.dto.MachineStatusHistoryDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("설비 상태 이력")
@RequestMapping(value = "/solutions/eone/wmd/machinestatushistory")
public class MachineStatusHistoryController {

	private final MachineStatusHistoryService machineStatusHistoryService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<MachineStatusHistoryDTO> getPagingList(MachineStatusHistoryDTO vo, PagingDTO page) throws Exception {
		return machineStatusHistoryService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<MachineStatusHistoryDTO> getList(MachineStatusHistoryDTO vo) throws Exception {
		return machineStatusHistoryService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(MachineStatusHistoryDTO vo) throws Exception {
		machineStatusHistoryService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(MachineStatusHistoryDTO vo) throws Exception {
		machineStatusHistoryService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(MachineStatusHistoryDTO vo) throws Exception {
		machineStatusHistoryService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<MachineStatusHistoryDTO> list) throws Exception {
		machineStatusHistoryService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<MachineStatusHistoryDTO> list) throws Exception {
		machineStatusHistoryService.deleteList(list);
	}

}