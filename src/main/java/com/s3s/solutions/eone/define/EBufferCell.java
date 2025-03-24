package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum EBufferCell {

	BufferCell1(1),
	BufferCell2(2),
	BufferCell3(3),
	BufferCell4(4),
	BufferCell5(5),
	BufferCell6(6),
	BufferCell7(7),
	BufferCell8(8),
	BufferCell9(9),
	BufferCell10(10),
	BufferCell11(11),
	BufferCell12(12);
	

	private int bufferCellId;

	private EBufferCell(int bufferCellId) {
		this.bufferCellId = bufferCellId;
	}

}
