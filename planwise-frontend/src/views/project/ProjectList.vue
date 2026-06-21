<template>
  <div class="project-list">
    <div class="page-header">
      <h2>📁 项目管理</h2>
      <el-button type="primary" @click="handleCreate">
        <el-icon><Plus /></el-icon>
        创建项目
      </el-button>
    </div>

    <div class="search-bar">
      <el-input
        v-model="keyword"
        placeholder="搜索项目..."
        clearable
        style="width: 300px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
    </div>

    <!-- 空状态 -->
    <el-empty description="暂无项目，点击上方按钮创建第一个项目">
      <template #image>
        <el-icon :size="80" color="#c0c4cc"><Folder /></el-icon>
      </template>
    </el-empty>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const keyword = ref('')

const handleCreate = () => {
  // TODO: 跳转到创建项目页
}
</script>

<style lang="scss" scoped>
.project-list {
  background: #fff;
  border-radius: 8px;
  padding: 24px;
  min-height: calc(100vh - 140px);
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;

  h2 {
    margin: 0;
    font-size: 20px;
    color: #303133;
  }
}

.search-bar {
  margin-bottom: 24px;
}
</style>
