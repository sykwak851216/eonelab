package com.s3s.solutions.eone.dmw.convertor;

import java.util.List;
import java.util.Map;
import java.util.stream.IntStream;

import com.ghgande.j2mod.modbus.procimg.InputRegister;
import com.s3s.sfp.apps.memory.ConvertPropertyServiceMemory;
import com.s3s.sfp.apps.service.dmw.convertproperty.ConvertPropertyVO;
import com.s3s.sfp.dmw.DMWDevice;
import com.s3s.sfp.dmw.converter.IDeviceConvertor;

public class GantryConvertor extends IDeviceConvertor<InputRegister> {
	@Override
	public void initialize() {
	}

	@Override
	public String getDeviceType() {
		return "gantry";
	}

	@Override
	public void decode(Map<String, InputRegister> orig, Map<String, DMWDevice> dest) {
		List<ConvertPropertyVO> list = ConvertPropertyServiceMemory.getPropertyList(getDeviceType());
		DMWDevice dmw = dest.get(getDeviceType());
		if (dmw != null) {
			/*
			for(ConvertPropertyVO vo : list) {
				IntStream.range(0, 3).forEach(i->{
					int val = (int) dmw.get(vo.getPropertyId());
					int bitVal = ((val >> (i * 2)) & 0x03);
					dmw.put(String.format("%s%d", vo.getPropertyId(), i + 1), String.valueOf(bitVal));
				});
			}
			*/
		}
	}
}
