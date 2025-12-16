<template>
  <div class="bg-white rounded-lg shadow-md">
    <!-- Group by selector -->
    <div class="border-b border-gray-200 px-6 py-4">
      <div class="flex items-center gap-4">
        <label class="text-sm font-medium text-gray-700">Group by:</label>
        <div class="flex gap-2">
          <button
            @click="groupBy = 'status'"
            :class="[
              'px-3 py-1.5 rounded-md text-sm font-medium transition',
              groupBy === 'status'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            ]"
          >
            Status
          </button>
          <button
            @click="groupBy = 'priority'"
            :class="[
              'px-3 py-1.5 rounded-md text-sm font-medium transition',
              groupBy === 'priority'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            ]"
          >
            Priority
          </button>
          <button
            @click="groupBy = 'date'"
            :class="[
              'px-3 py-1.5 rounded-md text-sm font-medium transition',
              groupBy === 'date'
                ? 'bg-blue-600 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            ]"
          >
            Due Date
          </button>
        </div>
      </div>
    </div>

    <!-- Task groups -->
    <div class="divide-y divide-gray-200">
      <div v-if="tasks.length === 0" class="px-6 py-12 text-center text-gray-500">
        <p class="text-lg mb-2">No tasks yet</p>
        <p class="text-sm">Click "Add New Task" to create your first task</p>
      </div>

      <div v-for="group in groupedTasks" :key="group.name" class="px-6 py-4">
        <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center gap-2">
          <span :class="getGroupBadgeClass(group.name)">
            {{ group.name }}
          </span>
          <span class="text-gray-500 font-normal">({{ group.tasks.length }})</span>
        </h3>

        <div class="space-y-2">
          <div
            v-for="task in group.tasks"
            :key="task.id"
            class="group flex items-start gap-4 p-3 rounded-lg hover:bg-gray-50 transition"
          >
            <!-- Checkbox -->
            <button
              @click="toggleTaskStatus(task)"
              class="flex-shrink-0 mt-1"
            >
              <div
                :class="[
                  'w-5 h-5 rounded border-2 flex items-center justify-center transition',
                  task.status === 'completed'
                    ? 'bg-green-500 border-green-500'
                    : 'border-gray-300 hover:border-green-500'
                ]"
              >
                <svg
                  v-if="task.status === 'completed'"
                  class="w-3 h-3 text-white"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                </svg>
              </div>
            </button>

            <!-- Task content -->
            <div class="flex-1 min-w-0">
              <div class="flex items-start justify-between gap-4">
                <div class="flex-1">
                  <h4
                    :class="[
                      'font-medium',
                      task.status === 'completed'
                        ? 'text-gray-500 line-through'
                        : 'text-gray-900'
                    ]"
                  >
                    {{ task.title }}
                  </h4>
                  <p
                    v-if="task.description"
                    :class="[
                      'text-sm mt-1',
                      task.status === 'completed' ? 'text-gray-400' : 'text-gray-600'
                    ]"
                  >
                    {{ task.description }}
                  </p>
                  <div class="flex items-center gap-3 mt-2 text-xs">
                    <span
                      :class="[
                        'px-2 py-1 rounded font-medium',
                        getPriorityClass(task.priority)
                      ]"
                    >
                      {{ task.priority }}
                    </span>
                    <span class="text-gray-500 flex items-center gap-1">
                      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                      </svg>
                      {{ formatDate(task.dueDate) }}
                    </span>
                    <span v-if="task.category" class="text-gray-500">
                      {{ task.category }}
                    </span>
                  </div>
                </div>

                <!-- Actions -->
                <div class="flex gap-1 opacity-0 group-hover:opacity-100 transition">
                  <button
                    @click="$emit('edit', task)"
                    class="p-1.5 text-blue-600 hover:bg-blue-50 rounded transition"
                    title="Edit"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                    </svg>
                  </button>
                  <button
                    @click="handleDelete(task)"
                    class="p-1.5 text-red-600 hover:bg-red-50 rounded transition"
                    title="Delete"
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Task } from '../composables/useTasks'

const props = defineProps<{
  tasks: Task[]
}>()

const emit = defineEmits<{
  edit: [task: Task]
  delete: [id: number]
  updateStatus: [id: number, status: Task['status']]
}>()

const groupBy = ref<'status' | 'priority' | 'date'>('status')

const groupedTasks = computed(() => {
  const groups: { name: string; tasks: Task[] }[] = []

  if (groupBy.value === 'status') {
    const statuses: Task['status'][] = ['pending', 'in-progress', 'completed']
    statuses.forEach(status => {
      const tasksInStatus = props.tasks.filter(t => t.status === status)
      if (tasksInStatus.length > 0) {
        groups.push({
          name: status.charAt(0).toUpperCase() + status.slice(1).replace('-', ' '),
          tasks: tasksInStatus
        })
      }
    })
  } else if (groupBy.value === 'priority') {
    const priorities: Task['priority'][] = ['high', 'medium', 'low']
    priorities.forEach(priority => {
      const tasksInPriority = props.tasks.filter(t => t.priority === priority)
      if (tasksInPriority.length > 0) {
        groups.push({
          name: priority.charAt(0).toUpperCase() + priority.slice(1),
          tasks: tasksInPriority
        })
      }
    })
  } else if (groupBy.value === 'date') {
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const overdue: Task[] = []
    const todayTasks: Task[] = []
    const upcoming: Task[] = []
    const future: Task[] = []

    props.tasks.forEach(task => {
      const dueDate = new Date(task.dueDate)
      dueDate.setHours(0, 0, 0, 0)
      const daysDiff = Math.floor((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24))

      if (daysDiff < 0) {
        overdue.push(task)
      } else if (daysDiff === 0) {
        todayTasks.push(task)
      } else if (daysDiff <= 7) {
        upcoming.push(task)
      } else {
        future.push(task)
      }
    })

    if (overdue.length > 0) groups.push({ name: 'Overdue', tasks: overdue })
    if (todayTasks.length > 0) groups.push({ name: 'Today', tasks: todayTasks })
    if (upcoming.length > 0) groups.push({ name: 'This Week', tasks: upcoming })
    if (future.length > 0) groups.push({ name: 'Future', tasks: future })
  }

  return groups
})

const getGroupBadgeClass = (name: string): string => {
  const lowerName = name.toLowerCase()

  if (lowerName === 'completed') return 'bg-green-100 text-green-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'in progress') return 'bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'pending') return 'bg-gray-100 text-gray-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'high') return 'bg-red-100 text-red-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'medium') return 'bg-yellow-100 text-yellow-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'low') return 'bg-green-100 text-green-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'overdue') return 'bg-red-100 text-red-800 px-2 py-1 rounded text-xs'
  if (lowerName === 'today') return 'bg-blue-100 text-blue-800 px-2 py-1 rounded text-xs'

  return 'bg-gray-100 text-gray-800 px-2 py-1 rounded text-xs'
}

const getPriorityClass = (priority: Task['priority']): string => {
  switch (priority) {
    case 'high':
      return 'bg-red-100 text-red-800'
    case 'medium':
      return 'bg-yellow-100 text-yellow-800'
    case 'low':
      return 'bg-green-100 text-green-800'
    default:
      return 'bg-gray-100 text-gray-800'
  }
}

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
  if (daysDiff < -1) return `${Math.abs(daysDiff)} days ago`
  if (daysDiff < 7) return `In ${daysDiff} days`

  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    year: date.getFullYear() !== today.getFullYear() ? 'numeric' : undefined
  })
}

const toggleTaskStatus = (task: Task) => {
  const newStatus = task.status === 'completed' ? 'pending' : 'completed'
  emit('updateStatus', task.id, newStatus)
}

const handleDelete = (task: Task) => {
  if (confirm(`Are you sure you want to delete "${task.title}"?`)) {
    emit('delete', task.id)
  }
}
</script>
