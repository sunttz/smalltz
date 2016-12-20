package com.stt.service;

import com.stt.entity.QueryLog;

public interface QueryLogService {

	/**
	 * 插入日志
	 * @param record
	 * @return
	 */
	public int insertLog(QueryLog record);
}
