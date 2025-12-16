<template>
  <div class="bg-white rounded-lg shadow-md overflow-hidden">
    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th scope="col" class="w-12 px-6 py-3">
              <input
                type="checkbox"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                @change="toggleAllTasks"
                :checked="allCompleted"
              />
            </th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Task
            </th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Priority
            </th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Status
            </th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Due Date
            </th>
            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
              Category
            </th>
            <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
              Actions
            </th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-if="tasks.length === 0">
            <td colspan="7" class="px-6 py-12 text-center text-gray-500">
              <p class="text-lg mb-2">No tasks yet</p>
              <p class="text-sm">Click "Add New Task" to create your first task</p>
            </td>
          </tr>
          <tr
            v-for="task in tasks"
            :key="task.id"
            class="hover:bg-gray-50 transition"
          >
            <!-- Checkbox -->
            <td class="px-6 py-4">
              <input
                type="checkbox"
                class="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                :checked="task.status === 'completed'"
                @change="toggleTaskStatus(task)"
              />
            </td>

            <!-- Task -->
            <td class="px-6 py-4">
              <div
                :class="[
                  'text-sm font-medium',
                  task.status === 'completed' ? 'text-gray-500 line-through' : 'text-gray-900'
                ]"
              >
                {{ task.title }}
              </div>
              <div
                v-if="task.description"
                :class="[
                  'text-sm mt-1',
                  task.status === 'completed' ? 'text-gray-400' : 'text-gray-500'
                ]"
              >
                {{ task.description }}
              </div>
            </td>

            <!-- Priority -->
            <td class="px-6 py-4 whitespace-nowrap">
              <span
                :class="[
                  'px-2 inline-flex text-xs leading-5 font-semibold rounded-full',
                  getPriorityClass(task.priority)
                ]"
              >
                {{ task.priority }}
              </span>
            </td>

            <!-- Status -->
            <td class="px-6 py-4 whitespace-nowrap">
              <span
                :class="[
                  'px-2 inline-flex text-xs leading-5 font-semibold rounded-full',
                  getStatusClass(task.status)
                ]"
              >
                {{ task.status.replace('-', ' ') }}
              </span>
            </td>

            <!-- Due Date -->
            <td class="px-6 py-4 whitespace-nowrap">
              <div class="flex items-center gap-2">
                <span
                  :class="[
                    'text-sm',
                    isOverdue(task.dueDate) && task.status !== 'completed'
                      ? 'text-red-600 font-medium'
                      : 'text-gray-900'
                  ]"
                >
                  {{ formatDate(task.dueDate) }}
                </span>
                <svg
                  v-if="isOverdue(task.dueDate) && task.status !== 'completed'"
                  class="w-4 h-4 text-red-600"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
            </td>

            <!-- Category -->
            <td class="px-6 py-4 whitespace-nowrap">
              <span class="text-sm text-gray-900">{{ task.category || '—' }}</span>
            </td>

            <!-- Actions -->
            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
              <div class="flex justify-end gap-2">
                <button
                  @click="$emit('edit', task)"
                  class="text-indigo-600 hover:text-indigo-900 p-1 hover:bg-indigo-50 rounded transition"
                  title="Edit"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                  </svg>
                </button>
                <button
                  @click="handleDelete(task)"
                  class="text-red-600 hover:text-red-900 p-1 hover:bg-red-50 rounded transition"
                  title="Delete"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                  </svg>
                </button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Task } from '../composables/useTasks'

const props = defineProps<{
  tasks: Task[]
}>()

const emit = defineEmits<{
  edit: [task: Task]
  delete: [id: number]
  updateStatus: [id: number, status: Task['status']]
}>()

const allCompleted = computed(() => {
  return props.tasks.length > 0 && props.tasks.every(task => task.status === 'completed')
})

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

const getStatusClass = (status: Task['status']): string => {
  switch (status) {
    case 'completed':
      return 'bg-green-100 text-green-800'
    case 'in-progress':
      return 'bg-blue-100 text-blue-800'
    case 'pending':
      return 'bg-gray-100 text-gray-800'
    default:
      return 'bg-gray-100 text-gray-800'
  }
}

const isOverdue = (dueDate: string): boolean => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  const taskDate = new Date(dueDate)
  taskDate.setHours(0, 0, 0, 0)
  return taskDate < today
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

const toggleAllTasks = () => {
  const newStatus = allCompleted.value ? 'pending' : 'completed'
  props.tasks.forEach(task => {
    if (task.status !== newStatus) {
      emit('updateStatus', task.id, newStatus)
    }
  })
}

const handleDelete = (task: Task) => {
  if (confirm(`Are you sure you want to delete "${task.title}"?`)) {
    emit('delete', task.id)
  }
}
</script>
