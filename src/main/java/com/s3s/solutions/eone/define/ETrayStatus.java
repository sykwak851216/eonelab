package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum ETrayStatus {
	READY("등록"), ING("진행중"), COMPLETE("완료");

	private String text;

	private ETrayStatus(String text) {
		this.text = text;
	}

}
