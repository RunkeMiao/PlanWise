package top.xiaocaohub.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;
import top.xiaocaohub.entity.User;

// 标记为 Mapper 接口
@Mapper
public interface UserMapper extends BaseMapper<User> {
    // BaseMapper 已经提供了基础的增删改查方法
    // 无需写任何代码
    /* BaseMapper 自带的方法：
            ┌─────────────────────┬──────────────┐
            │        方法         │     作用     │
            ├─────────────────────┼──────────────┤
            │ insert(T)           │ 插入一条记录 │
            ├─────────────────────┼──────────────┤
            │ deleteById(ID)      │ 根据 ID 删除 │
            ├─────────────────────┼──────────────┤
            │ updateById(T)       │ 根据 ID 更新 │
            ├─────────────────────┼──────────────┤
            │ selectById(ID)      │ 根据 ID 查询 │
            ├─────────────────────┼──────────────┤
            │ selectList(Wrapper) │ 条件查询列表 │
            ├─────────────────────┼──────────────┤
            │ selectOne(Wrapper)  │ 条件查询单条 │
            └─────────────────────┴──────────────┘*/

}
