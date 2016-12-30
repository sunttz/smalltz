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
    
    /**
     * 根据用户名统计地域分布
     * @param name
     * @return
     */
    List<Map<String, Object>> selectMap(@Param("name") String name);

    /**
     * 根据用户名统计城市分布
     * @param name
     * @return
     */
    List<Map<String, Object>> selectCityMap(@Param("name") String name,@Param("province") String province);
    
    /**
     * 根据用户名查询排名
     * @param name
     * @return
     */
    Map<String, Object> selectRank(@Param("name") String name);
}