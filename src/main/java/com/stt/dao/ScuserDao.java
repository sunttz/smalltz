package com.stt.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.stt.entity.Scuser;

public interface ScuserDao {
    int deleteByPrimaryKey(Integer id);

    int insert(Scuser record);

    int insertSelective(Scuser record);

    Scuser selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Scuser record);

    int updateByPrimaryKey(Scuser record);
    
    /**
     * 根据用户名查询用户列表
     * @param name
     * @return
     */
    List<Scuser> selectUserByName(@Param("name") String name);

    /**
     * 根据用户名统计男女比例
     * @param name
     * @return
     */
    List<Map<String, Object>> selectSexPie(@Param("name") String name);

    /**
     * 根据用户名统计年龄分布
     * @param name
     * @return
     */
    List<Map<String, Object>> selectBirLine(@Param("name") String name);
}