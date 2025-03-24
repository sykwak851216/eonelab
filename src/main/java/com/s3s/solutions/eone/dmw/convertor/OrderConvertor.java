package com.s3s.solutions.eone.dmw.convertor;

import java.util.HashMap;
import java.util.Map;
import java.util.stream.IntStream;

import com.ghgande.j2mod.modbus.procimg.InputRegister;
import com.s3s.sfp.dmw.DMWDevice;
import com.s3s.sfp.dmw.converter.IDeviceConvertor;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class OrderConvertor extends IDeviceConvertor<InputRegister> {
	@Override
	public void initialize() {
	}

	@Override
	public String getDeviceType() {
		return "order";
	}

	/*
	 * 트레이 처리 상태
	 */
	@Override
	public void decode(Map<String, InputRegister> orig, Map<String, DMWDevice> dest) {
		DMWDevice dmw = dest.get(getDeviceType());
		if(dmw != null) {
			Map<String, Object> bufferList = new HashMap<String, Object>();
			
			IntStream.range(1, 13).forEach(i->{
				String trayId = ((String)dmw.get(String.format("%s%s", "orderProcBufferQRReadInfo", i))).trim();
//				if (trayId.length() > 0 && trayId.length() > 4) {
//					trayId = trayId.substring(trayId.length()-4, trayId.length());
//				}
				dmw.put(String.format("%s%s", "orderProcBufferQRReadInfo", i), trayId);//뒤 공백제거
				
				Map<String, String> bufferInfo = new HashMap<String, String>();
				bufferInfo.put("orderProcBufferRack", dmw.get(String.format("%s%s", "orderProcBufferRack", i)).toString());
				bufferInfo.put("orderProcBufferX", dmw.get(String.format("%s%s", "orderProcBufferX", i)).toString());
				bufferInfo.put("orderProcBufferY", dmw.get(String.format("%s%s", "orderProcBufferY", i)).toString());
				bufferInfo.put("orderProcBufferQRReadStatus", dmw.get(String.format("%s%s", "orderProcBufferQRReadStatus", i)).toString());
				bufferInfo.put("orderProcBufferQRReadInfo", dmw.get(String.format("%s%s", "orderProcBufferQRReadInfo", i)).toString());
				
				bufferList.put(Integer.toString(i), bufferInfo);
				
			});
			dmw.put("orderTrayProcStatus", bufferList);
		}
	}
}
