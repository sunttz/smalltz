package com.stt.service.impl;

import com.stt.dao.HatProvinceDao;
import com.stt.entity.HatProvince;
import com.stt.service.HatProvinceService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * Created by Administrator on 2016/12/15.
 */
@Service("hatProvinceService")
public class HatProvinceServiceImpl implements HatProvinceService {
    @Resource
    private HatProvinceDao hatProvinceDao;
    @Override
    public HatProvince getHatProvinceById(int sid) {
        return this.hatProvinceDao.selectByPrimaryKey(sid);
    }
}
