package com.s3s.solutions.eone.dmw.convertor;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.IntStream;

import com.ghgande.j2mod.modbus.procimg.InputRegister;
import com.s3s.sfp.dmw.DMWDevice;
import com.s3s.sfp.dmw.converter.IDeviceConvertor;
import com.s3s.solutions.eone.EoneConst;

public class BufferConvertor extends IDeviceConvertor<InputRegister> {
	@Override
	public void initialize() {

	}

	@Override
	public String getDeviceType() {
		return "buffer";
	}

	@Override
	public void decode(Map<String, InputRegister> orig, Map<String, DMWDevice> dest) {
		DMWDevice dmw = dest.get(getDeviceType());
		if(dmw != null) {
			int p = (int) dmw.get("bufferCellSensingResult");
			Map<String, String> bufferStatus = new HashMap<String, String>();
			IntStream.range(0, EoneConst.MAX_BUFFER_CELL_SIZE).forEach(i->{
				bufferStatus.put(String.valueOf(i+1), (p >> i & 0x01) == 1 ? EoneConst.BOX_ON : EoneConst.BOX_OFF);
			});
			dmw.put("bufferCellStatus", bufferStatus);
		}
	}
}
