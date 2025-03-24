package com.s3s.solutions.eone.controller.wmd;

import java.util.List;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.s3s.solutions.eone.service.wmd.machine.MachineService;
import com.s3s.solutions.eone.service.wmd.machine.dto.MachineDTO;
import com.s3s.sfp.security.Authority;
import com.s3s.sfp.service.common.PagingDTO;
import com.s3s.sfp.service.common.PagingListDTO;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@Authority("설비")
@RequestMapping(value = "/solutions/eone/wmd/machine")
public class MachineController {

	private final MachineService machineService;

	@RequestMapping(value = { "/getPagingList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public PagingListDTO<MachineDTO> getPagingList(MachineDTO vo, PagingDTO page) throws Exception {
		return machineService.getPagingList(vo, page);
	}

	@RequestMapping(value = { "/getList" }, method = { RequestMethod.POST, RequestMethod.GET })
	public List<MachineDTO> getList(MachineDTO vo) throws Exception {
		return machineService.getList(vo);
	}

	@RequestMapping(value = "/add", method = { RequestMethod.GET, RequestMethod.POST })
	public void add(MachineDTO vo) throws Exception {
		machineService.add(vo);
	}

	@RequestMapping(value = "/modify", method = { RequestMethod.GET, RequestMethod.POST })
	public void modify(MachineDTO vo) throws Exception {
		machineService.modify(vo);
	}

	@RequestMapping(value = "/delete", method = { RequestMethod.GET, RequestMethod.POST })
	public void delete(MachineDTO vo) throws Exception {
		machineService.delete(vo);
	}

	@RequestMapping(value = "/saveList", method = { RequestMethod.GET, RequestMethod.POST })
	public void saveList(@RequestBody List<MachineDTO> list) throws Exception {
		machineService.saveList(list);
	}

	@RequestMapping(value = "/deleteList", method = { RequestMethod.GET, RequestMethod.POST })
	public void deleteList(@RequestBody List<MachineDTO> list) throws Exception {
		machineService.deleteList(list);
	}

}