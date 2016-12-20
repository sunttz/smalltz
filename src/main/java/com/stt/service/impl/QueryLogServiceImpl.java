package com.stt.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.stt.dao.QueryLogDao;
import com.stt.entity.QueryLog;
import com.stt.service.QueryLogService;

@Service("queryLogService")
public class QueryLogServiceImpl implements QueryLogService {

	@Resource
	private QueryLogDao queryLogDao;
	@Override
	public int insertLog(QueryLog record) {
		return queryLogDao.insertSelective(record);
	}

}
