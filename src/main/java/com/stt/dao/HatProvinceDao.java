package com.stt.dao;


import com.stt.entity.HatProvince;
import org.springframework.stereotype.Repository;

public interface HatProvinceDao {
    int deleteByPrimaryKey(Integer sid);

    int insert(HatProvince record);

    int insertSelective(HatProvince record);

    HatProvince selectByPrimaryKey(Integer sid);

    int updateByPrimaryKeySelective(HatProvince record);

    int updateByPrimaryKey(HatProvince record);
}