<template>
  <div class="profile-container">
    <el-card class="profile-card">
      <template #header>
        <div class="card-header">
          <span>个人信息</span>
        </div>
      </template>

      <el-tabs v-model="activeTab">
        <!-- 基本信息 -->
        <el-tab-pane label="基本信息" name="info">
          <div class="profile-content">
            <!-- 头像区域 -->
            <div class="avatar-section">
              <el-avatar
                :size="100"
                class="avatar"
                :src="avatarUrl"
              >
                {{ userInfo.username?.charAt(0)?.toUpperCase() }}
              </el-avatar>
              <el-upload
                :show-file-list="false"
                :before-upload="beforeAvatarUpload"
                :http-request="handleAvatarUpload"
                accept="image/jpeg,image/png"
              >
                <el-button size="small" type="primary" :loading="avatarLoading">
                  <el-icon><Upload /></el-icon>
                  更换头像
                </el-button>
              </el-upload>
              <p class="avatar-tip">支持 JPG/PNG，最大 2MB</p>
            </div>

            <!-- 信息表单 -->
            <el-form
              ref="infoFormRef"
              :model="infoForm"
              :rules="infoRules"
              label-width="80px"
              class="info-form"
            >
              <el-form-item label="用户名">
                <el-input v-model="infoForm.username" disabled />
              </el-form-item>
              <el-form-item label="真实姓名" prop="realName">
                <el-input v-model="infoForm.realName" placeholder="请输入真实姓名" />
              </el-form-item>
              <el-form-item label="邮箱" prop="email">
                <el-input v-model="infoForm.email" placeholder="请输入邮箱" />
              </el-form-item>
              <el-form-item label="手机号" prop="phone">
                <el-input v-model="infoForm.phone" placeholder="请输入手机号" />
              </el-form-item>
              <el-form-item label="注册时间">
                <el-input v-model="infoForm.createTime" disabled />
              </el-form-item>
              <el-form-item>
                <el-button type="primary" :loading="infoLoading" @click="handleUpdateInfo">
                  保存修改
                </el-button>
                <el-button @click="resetInfoForm">重置</el-button>
              </el-form-item>
            </el-form>
          </div>
        </el-tab-pane>

        <!-- 修改密码 -->
        <el-tab-pane label="修改密码" name="password">
          <el-form
            ref="pwdFormRef"
            :model="pwdForm"
            :rules="pwdRules"
            label-width="100px"
            class="pwd-form"
          >
            <el-form-item label="原密码" prop="oldPassword">
              <el-input
                v-model="pwdForm.oldPassword"
                type="password"
                placeholder="请输入原密码"
                show-password
              />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input
                v-model="pwdForm.newPassword"
                type="password"
                placeholder="请输入新密码（6-20位）"
                show-password
              />
            </el-form-item>
            <el-form-item label="确认新密码" prop="confirmPassword">
              <el-input
                v-model="pwdForm.confirmPassword"
                type="password"
                placeholder="请再次输入新密码"
                show-password
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" :loading="pwdLoading" @click="handleUpdatePassword">
                修改密码
              </el-button>
              <el-button @click="resetPwdForm">重置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { updateUser, updatePassword, uploadAvatar } from '@/api/user'
import { ElMessage } from 'element-plus'

const userStore = useUserStore()
const userInfo = ref({})

// 头像 URL：如果 avatar 为空或 null 则不传 src，让 el-avatar 显示首字母
const avatarUrl = computed(() => {
  const avatar = userInfo.value.avatar
  if (!avatar) return undefined
  return avatar
})

const activeTab = ref('info')
const infoFormRef = ref(null)
const pwdFormRef = ref(null)
const infoLoading = ref(false)
const pwdLoading = ref(false)
const avatarLoading = ref(false)

// 基本信息表单
const infoForm = reactive({
  username: '',
  realName: '',
  email: '',
  phone: '',
  createTime: ''
})

// 密码表单
const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 邮箱校验
const validateEmail = (rule, value, callback) => {
  if (value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
    callback(new Error('请输入正确的邮箱格式'))
  } else {
    callback()
  }
}

// 手机号校验
const validatePhone = (rule, value, callback) => {
  if (value && !/^1[3-9]\d{9}$/.test(value)) {
    callback(new Error('请输入正确的手机号格式'))
  } else {
    callback()
  }
}

// 确认密码校验
const validateConfirmPassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入新密码'))
  } else if (value !== pwdForm.newPassword) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const infoRules = {
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  email: [{ validator: validateEmail, trigger: 'blur' }],
  phone: [{ validator: validatePhone, trigger: 'blur' }]
}

const pwdRules = {
  oldPassword: [
    { required: true, message: '请输入原密码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度为 6-20 位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

// 初始化：获取用户信息
onMounted(async () => {
  try {
    const res = await userStore.fetchUserInfo()
    userInfo.value = res.data
    fillInfoForm(res.data)
  } catch (error) {
    console.error('获取用户信息失败:', error)
  }
})

// 填充信息表单
function fillInfoForm(data) {
  infoForm.username = data.username || ''
  infoForm.realName = data.realName || ''
  infoForm.email = data.email || ''
  infoForm.phone = data.phone || ''
  infoForm.createTime = data.createTime || ''
}

// 重置信息表单
function resetInfoForm() {
  fillInfoForm(userInfo.value)
}

// 保存基本信息
async function handleUpdateInfo() {
  if (!infoFormRef.value) return
  try {
    await infoFormRef.value.validate()
  } catch {
    return
  }

  infoLoading.value = true
  try {
    await updateUser({
      realName: infoForm.realName || null,
      email: infoForm.email || null,
      phone: infoForm.phone || null
    })
    ElMessage.success('修改成功')
    // 刷新用户信息
    const res = await userStore.fetchUserInfo()
    userInfo.value = res.data
  } catch (error) {
    console.error('修改失败:', error)
  } finally {
    infoLoading.value = false
  }
}

// 重置密码表单
function resetPwdForm() {
  pwdFormRef.value?.resetFields()
}

// 修改密码
async function handleUpdatePassword() {
  if (!pwdFormRef.value) return
  try {
    await pwdFormRef.value.validate()
  } catch {
    return
  }

  pwdLoading.value = true
  try {
    await updatePassword({
      oldPassword: pwdForm.oldPassword,
      newPassword: pwdForm.newPassword
    })
    ElMessage.success('密码修改成功，请重新登录')
    userStore.logout()
    window.location.href = '/login'
  } catch (error) {
    console.error('密码修改失败:', error)
  } finally {
    pwdLoading.value = false
  }
}

// 头像上传前校验
function beforeAvatarUpload(file) {
  const isImage = ['image/jpeg', 'image/png'].includes(file.type)
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('头像只能是 JPG 或 PNG 格式')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('头像大小不能超过 2MB')
    return false
  }
  return true
}

// 自定义头像上传
async function handleAvatarUpload(options) {
  avatarLoading.value = true
  try {
    const res = await uploadAvatar(options.file)
    // 通知 Element Plus 上传成功
    options.onSuccess(res)
    ElMessage.success('头像上传成功')
    // 更新 store 和本地
    const infoRes = await userStore.fetchUserInfo()
    userInfo.value = infoRes.data
  } catch (error) {
    console.error('头像上传失败:', error)
    options.onError(error)
  } finally {
    avatarLoading.value = false
  }
}
</script>

<style lang="scss" scoped>
.profile-container {
  max-width: 800px;
  margin: 0 auto;
}

.profile-card {
  .card-header {
    font-size: 18px;
    font-weight: 600;
    color: #303133;
  }
}

.profile-content {
  display: flex;
  gap: 40px;
  padding-top: 10px;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  flex-shrink: 0;

  .avatar {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: #fff;
    font-size: 36px;
  }

  .avatar-tip {
    font-size: 12px;
    color: #909399;
    margin: 0;
  }
}

.info-form {
  flex: 1;
  max-width: 400px;
}

.pwd-form {
  max-width: 400px;
  padding-top: 10px;
}
</style>
