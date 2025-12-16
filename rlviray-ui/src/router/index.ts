import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router'
import { useAuth } from '../composables/useAuth'
import LandingPage from '../components/LandingPage.vue'
import Login from '../views/Login.vue'
import Dashboard from '../views/Dashboard.vue'
import TasksView from '../views/TasksView.vue'
import LinksView from '../views/LinksView.vue'
import TimerView from '../views/TimerView.vue'
import SpendingView from '../views/SpendingView.vue'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'Home',
    component: LandingPage,
    meta: { requiresAuth: false }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login,
    meta: { requiresAuth: false }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: Dashboard,
    meta: { requiresAuth: true }
  },
  {
    path: '/tasks',
    name: 'Tasks',
    component: TasksView,
    meta: { requiresAuth: true }
  },
  {
    path: '/timer',
    name: 'Timer',
    component: TimerView,
    meta: { requiresAuth: true }
  },
  {
    path: '/spending',
    name: 'Spending',
    component: SpendingView,
    meta: { requiresAuth: true }
  },
  {
    path: '/links',
    name: 'Links',
    component: LinksView,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Route guard to protect private routes
router.beforeEach((to, from, next) => {
  const { isAuthenticated } = useAuth()

  if (to.meta.requiresAuth && !isAuthenticated.value) {
    // Redirect to home page if not authenticated
    next({ name: 'Home' })
  } else if (to.name === 'Login' && isAuthenticated.value) {
    // Redirect to dashboard if already logged in
    next({ name: 'Dashboard' })
  } else {
    next()
  }
})

export default router
