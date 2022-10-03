package com.example.web.service;



import com.example.web.pojo.User;
import org.springframework.stereotype.Service;


import java.util.List;

@Service
public interface UserService  {

    //查询所有
    List<User> getUserAll();

    //增加
    boolean addUser(User user);

    //修改
    boolean updateUser(User user);

    //删除
    boolean deleteUser(Integer id);
}
