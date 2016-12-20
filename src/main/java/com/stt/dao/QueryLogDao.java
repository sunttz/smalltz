package com.stt.dao;

import com.stt.entity.QueryLog;

public interface QueryLogDao {
    int deleteByPrimaryKey(Integer id);

    int insert(QueryLog record);

    int insertSelective(QueryLog record);

    QueryLog selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(QueryLog record);

    int updateByPrimaryKey(QueryLog record);
}