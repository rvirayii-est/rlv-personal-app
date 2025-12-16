<template>
  <SideNav>
    <div class="p-6">
      <!-- Welcome Section -->
      <div class="bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg p-6 text-white mb-6">
        <h1 class="text-3xl font-bold mb-2">Welcome back, {{ currentUser?.name }}!</h1>
        <p class="text-blue-100">Here's what's happening with your tasks and links today</p>
      </div>

      <!-- Stats Grid -->
      <div class="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-4 mb-8">
        <div
          v-for="stat in stats"
          :key="stat.label"
          class="bg-white overflow-hidden shadow rounded-lg hover:shadow-lg transition"
        >
          <div class="p-5">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <div :class="['rounded-md p-3', stat.bgColor]">
                  <component :is="stat.icon" class="w-6 h-6 text-white" />
                </div>
              </div>
              <div class="ml-5 w-0 flex-1">
                <dt class="text-sm font-medium text-gray-500 truncate">
                  {{ stat.label }}
                </dt>
                <dd class="mt-1 text-3xl font-semibold text-gray-900">
                  {{ stat.value }}
                </dd>
              </div>
            </div>
          </div>
          <div :class="['px-5 py-3', stat.bgColorLight]">
            <div class="text-sm">
              <router-link :to="stat.link" :class="['font-medium', stat.textColor, 'hover:underline']">
                View all
              </router-link>
            </div>
          </div>
        </div>
      </div>

      <!-- Two Column Layout -->
      <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <!-- Recent Tasks -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-semibold text-gray-900">Recent Tasks</h3>
            <router-link
              to="/tasks"
              class="text-sm font-medium text-blue-600 hover:text-blue-700"
            >
              View all →
            </router-link>
          </div>
          <div class="p-6">
            <div v-if="recentTasks.length === 0" class="text-center py-8 text-gray-500">
              <p>No tasks yet</p>
            </div>
            <div v-else class="space-y-3">
              <div
                v-for="task in recentTasks"
                :key="task.id"
                class="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 transition"
              >
                <div
                  :class="[
                    'w-2 h-2 rounded-full mt-2 flex-shrink-0',
                    task.priority === 'high' ? 'bg-red-500' :
                    task.priority === 'medium' ? 'bg-yellow-500' : 'bg-green-500'
                  ]"
                ></div>
                <div class="flex-1 min-w-0">
                  <p
                    :class="[
                      'text-sm font-medium',
                      task.status === 'completed' ? 'text-gray-500 line-through' : 'text-gray-900'
                    ]"
                  >
                    {{ task.title }}
                  </p>
                  <p class="text-xs text-gray-500 mt-1">
                    Due: {{ formatDate(task.dueDate) }}
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Recent Links -->
        <div class="bg-white shadow rounded-lg">
          <div class="px-6 py-4 border-b border-gray-200 flex justify-between items-center">
            <h3 class="text-lg font-semibold text-gray-900">Recent Links</h3>
            <router-link
              to="/links"
              class="text-sm font-medium text-blue-600 hover:text-blue-700"
            >
              View all →
            </router-link>
          </div>
          <div class="p-6">
            <div v-if="recentLinks.length === 0" class="text-center py-8 text-gray-500">
              <p>No links yet</p>
            </div>
            <div v-else class="space-y-3">
              <a
                v-for="link in recentLinks"
                :key="link.id"
                :href="link.url"
                target="_blank"
                rel="noopener noreferrer"
                class="flex items-start gap-3 p-3 rounded-lg hover:bg-gray-50 transition group"
              >
                <svg class="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1" />
                </svg>
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-medium text-gray-900 group-hover:text-blue-600">
                    {{ link.title }}
                  </p>
                  <p class="text-xs text-gray-500 truncate mt-1">
                    {{ link.url }}
                  </p>
                </div>
              </a>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="bg-white shadow rounded-lg mt-6">
        <div class="px-6 py-4 border-b border-gray-200">
          <h3 class="text-lg font-semibold text-gray-900">Recent Activity</h3>
        </div>
        <div class="p-6">
          <div class="flow-root">
            <ul class="-my-5 divide-y divide-gray-200">
              <li
                v-for="activity in recentActivity"
                :key="activity.id"
                class="py-4"
              >
                <div class="flex items-center space-x-4">
                  <div class="flex-shrink-0">
                    <div class="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center">
                      <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                      </svg>
                    </div>
                  </div>
                  <div class="flex-1 min-w-0">
                    <p class="text-sm font-medium text-gray-900 truncate">
                      {{ activity.title }}
                    </p>
                    <p class="text-sm text-gray-500">
                      {{ activity.description }}
                    </p>
                  </div>
                  <div class="text-sm text-gray-500">
                    {{ activity.time }}
                  </div>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </SideNav>
</template>

<script setup lang="ts">
import { ref, computed, h } from 'vue'
import { useAuth } from '../composables/useAuth'
import { useLinks } from '../composables/useLinks'
import { useTasks } from '../composables/useTasks'
import SideNav from '../components/SideNav.vue'

const { currentUser } = useAuth()
const { links } = useLinks()
const { tasks } = useTasks()

// Computed stats based on actual data
const stats = computed(() => {
  const totalTasks = tasks.value.length
  const completedTasks = tasks.value.filter(t => t.status === 'completed').length
  const pendingTasks = tasks.value.filter(t => t.status === 'pending' || t.status === 'in-progress').length
  const totalLinks = links.value.length

  return [
    {
      label: 'Total Tasks',
      value: totalTasks.toString(),
      icon: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2' })
      ]),
      bgColor: 'bg-blue-500',
      bgColorLight: 'bg-blue-50',
      textColor: 'text-blue-600',
      link: '/tasks'
    },
    {
      label: 'Pending Tasks',
      value: pendingTasks.toString(),
      icon: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z' })
      ]),
      bgColor: 'bg-yellow-500',
      bgColorLight: 'bg-yellow-50',
      textColor: 'text-yellow-600',
      link: '/tasks'
    },
    {
      label: 'Completed',
      value: completedTasks.toString(),
      icon: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z' })
      ]),
      bgColor: 'bg-green-500',
      bgColorLight: 'bg-green-50',
      textColor: 'text-green-600',
      link: '/tasks'
    },
    {
      label: 'Saved Links',
      value: totalLinks.toString(),
      icon: h('svg', { fill: 'none', stroke: 'currentColor', viewBox: '0 0 24 24' }, [
        h('path', { 'stroke-linecap': 'round', 'stroke-linejoin': 'round', 'stroke-width': '2', d: 'M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1' })
      ]),
      bgColor: 'bg-purple-500',
      bgColorLight: 'bg-purple-50',
      textColor: 'text-purple-600',
      link: '/links'
    }
  ]
})

// Recent tasks (last 5)
const recentTasks = computed(() => {
  return tasks.value.slice(0, 5)
})

// Recent links (last 5)
const recentLinks = computed(() => {
  return links.value.slice(0, 5)
})

// TODO: Replace with actual API call
const recentActivity = ref([
  {
    id: 1,
    title: 'Project Alpha completed',
    description: 'Successfully delivered all milestones',
    time: '2 hours ago'
  },
  {
    id: 2,
    title: 'New task assigned',
    description: 'Design review for Project Beta',
    time: '5 hours ago'
  },
  {
    id: 3,
    title: 'Meeting scheduled',
    description: 'Team sync on Friday at 2 PM',
    time: '1 day ago'
  }
])

const formatDate = (dateString: string): string => {
  const date = new Date(dateString)
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const taskDate = new Date(date)
  taskDate.setHours(0, 0, 0, 0)

  const daysDiff = Math.floor((taskDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))

  if (daysDiff === 0) return 'Today'
  if (daysDiff === 1) return 'Tomorrow'
  if (daysDiff === -1) return 'Yesterday'

  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric'
  })
}
</script>
