package com.example.web.mapper;

import com.example.web.pojo.User;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
/*
* 范型接口
* */
@Mapper
public interface IMapper<T> {


    //判断是否存在-name
    T getByName(String Name);

    //判断是否存在-id
    T getById(Integer id);

    //查询所有
    List<T> getAll();

    //增
    boolean add(T t);

    //改
    boolean update(T t);

    //删
    boolean delete(T t);
}
