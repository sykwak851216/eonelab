package com.s3s.solutions.eone.dmw;

import com.s3s.sfp.dmw.DMWManager;
import com.s3s.sfp.dmw.handler.ModbusTCPHandler;
import com.s3s.solutions.eone.dmw.convertor.BufferConvertor;
import com.s3s.solutions.eone.dmw.convertor.GantryConvertor;
import com.s3s.solutions.eone.dmw.convertor.OrderConvertor;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Slf4j
public class PLCModbusTCPHandler extends ModbusTCPHandler {

	private final int HEART_BEAT_PERIOD = 5000;
	private final int HEART_BEAT_ADDR = 261;

	@Override
	public void initialize() {
		super.initialize();
		DMWManager.getExecutor().execute(()->sendHeartbeat());
	}

	@Override
	public void registConvertor() {
		super.registConvertor();
		addConvertor(BufferConvertor.class);
		addConvertor(OrderConvertor.class);
		addConvertor(GantryConvertor.class);
	}

	public void sendHeartbeat() {
		while (isStarted()) {
			try {
				if (!isClosed()) {
					send("Heartbeat", HEART_BEAT_ADDR, 1);
				}
			} catch (Exception e) {
				log.error("sendHeartbeat error["
						+ getSystem().getSystemId() + "-" + getSystem().getSystemIp() + ":" + getSystem().getSystemPort() + "]", e);
				try {
					close();
				} catch (Exception e1) {
					log.error(e1.getMessage(), e1);
				}
			}

			try {
				Thread.sleep(HEART_BEAT_PERIOD);
			} catch (InterruptedException e) {
				log.error(e.getMessage(), e);
			}
		}
	}
}