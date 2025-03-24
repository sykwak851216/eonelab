package com.s3s.solutions.eone.manager;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.IntStream;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.s3s.solutions.eone.EoneConst;
import com.s3s.solutions.eone.dmw.command.PLCCommand;
import com.s3s.solutions.eone.dmw.command.message.body.BufferReportBody;

@Service
public class BufferManager {

	/**
	 * 버퍼 센서 목록
	 * @return
	 */
	/*
	public List<BufferSensorVO> getBufferSensors(){
		List<BufferSensorVO> bufferSensorList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			BufferSensorVO bufferSensorVO = getBufferSensor(String.valueOf(r));
			if(bufferSensorVO != null	) {
				bufferSensorList.add(bufferSensorVO);
			}
		});
		return bufferSensorList;
	}
	*/
	
	/**
	 * 라인별 버퍼 센서 목록
	 * @return
	 */
	public List<BufferSensorVO> getBufferSensorsByLineNo(String lineNo){
		List<BufferSensorVO> bufferSensorList = new ArrayList<>();
		IntStream.range(1, (EoneConst.MAX_BUFFER_CELL_SIZE + 1)).forEach(r -> {
			BufferSensorVO bufferSensorVO = getBufferSensorByLineNo(String.valueOf(r), lineNo);
			if(bufferSensorVO != null	) {
				bufferSensorList.add(bufferSensorVO);
			}
		});
		return bufferSensorList;
	}

	/**
	 * 개별 버퍼 센서 상태
	 * @param bufferId
	 * @return
	 */
	/*
	public BufferSensorVO getBufferSensor(String bufferId){
		if(StringUtils.isEmpty(bufferId)) {
			return null;
		}
		BufferReportBody bufferReportBody = PLCCommand.getBuffer();
		Map<String, String> bufferCellStatus = Optional.ofNullable(bufferReportBody.getBufferCellStatus()).orElse(new HashMap<String, String>());
		String sensor = Optional.ofNullable(bufferCellStatus.get(bufferId)).orElse("0");
		return new BufferSensorVO(){{
			setBufferId(bufferId);
			setSensor(sensor);
		}};
	}
	*/
	
	/**
	 * 개별 버퍼 센서 상태
	 * @param bufferId
	 * @return
	 */
	public BufferSensorVO getBufferSensorByLineNo(String bufferId, String lineNo){
		if (StringUtils.isEmpty(bufferId) || StringUtils.isEmpty(lineNo)) {
			return null;
		}
		//FIXME
		BufferReportBody bufferReportBody = PLCCommand.getBuffer(lineNo);
		Map<String, String> bufferCellStatus = Optional.ofNullable(bufferReportBody.getBufferCellStatus()).orElse(new HashMap<String, String>());
		String sensor = Optional.ofNullable(bufferCellStatus.get(bufferId)).orElse("0");
		return new BufferSensorVO(){{
			setBufferId(bufferId);
			setSensor(sensor);
		}};
	}

	/**
	 * 버퍼 센서 ON 개수
	 * @return
	 */
	/*
	public long getBufferSensorOnCount() {
		List<BufferSensorVO> bufferSensorList = this.getBufferSensors();
		return bufferSensorList.stream().filter(r -> StringUtils.equals(r.getSensor(), "1")).count();
	}
	*/
	
	/**
	 * 버퍼 센서 ON 개수
	 * @return
	 */
	public long getBufferSensorOnCountByLineNo(String lineNo) {
		List<BufferSensorVO> bufferSensorList = this.getBufferSensorsByLineNo(lineNo);
		return bufferSensorList.stream().filter(r -> StringUtils.equals(r.getSensor(), "1")).count();
	}
}
