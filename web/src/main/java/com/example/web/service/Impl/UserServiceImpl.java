package com.example.web.service.Impl;


import com.example.web.mapper.IMapper;
import com.example.web.pojo.User;
import com.example.web.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service("userService")
public class UserServiceImpl implements UserService {
    @Autowired
    private IMapper userDao;

    @Override
    public List<User> getUserAll() {
        return userDao.getAll();
    }

    @Override
    public boolean addUser(User user) {
        User user1 = (User) userDao.getByName(user.getLoginName());
        if (user1 == null) {
            System.out.println("后台显示：成功！");
            return userDao.add(user);
        } else {
            System.out.println("后台显示：用户已存在！");
            return false;
        }
    }

    @Override
    public boolean updateUser(User user) {
        User u = (User) userDao.getById(user.getId());
        try {
            if (u == null) {
                System.out.println("后台显示：失败！");
                return false;
            } else {
                System.out.println("后台显示：成功！");
                return userDao.update(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteUser(Integer id) {
        User u = (User) userDao.getById(id);
        if (u != null){
            System.out.println("后台显示：成功！");
            return userDao.delete(id);
        }else {
            System.out.println("后台显示：失败！");
            return false;
        }

    }
}
