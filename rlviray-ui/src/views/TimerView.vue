<template>
  <SideNav>
    <div class="flex-1 flex flex-col">
      <!-- Header -->
      <div class="bg-white border-b border-gray-200 px-6 py-4">
        <div>
          <h1 class="text-2xl font-bold text-gray-900">Time Tracker</h1>
          <p class="text-sm text-gray-600 mt-1">Track time spent on your tasks</p>
        </div>
      </div>

      <!-- Content -->
      <div class="flex-1 overflow-auto p-6">
        <div class="max-w-6xl mx-auto space-y-6">
          <!-- Active Timer Section -->
          <div
            :class="[
              'rounded-lg p-8 text-white',
              isTimerRunning
                ? 'bg-gradient-to-r from-green-600 to-emerald-600'
                : 'bg-gradient-to-r from-gray-600 to-gray-700'
            ]"
          >
            <div class="text-center">
              <div class="flex items-center justify-center gap-2 mb-2">
                <div
                  v-if="isTimerRunning"
                  class="w-3 h-3 bg-white rounded-full animate-pulse"
                ></div>
                <h2 class="text-lg font-semibold">
                  {{ isTimerRunning ? 'Timer Running' : 'No Active Timer' }}
                </h2>
              </div>

              <div class="text-6xl font-bold mb-4 font-mono">
                {{ formatDisplayTime(elapsedTime) }}
              </div>

              <div v-if="activeEntry" class="mb-6">
                <p class="text-xl mb-2">{{ activeEntry.taskTitle }}</p>
                <p v-if="activeEntry.description" class="text-green-100">
                  {{ activeEntry.description }}
                </p>
              </div>

              <div class="flex justify-center gap-4">
                <button
                  v-if="!isTimerRunning"
                  @click="showStartDialog = true"
                  class="bg-white text-green-600 px-8 py-3 rounded-lg font-semibold hover:bg-green-50 transition flex items-center gap-2"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Start Timer
                </button>

                <button
                  v-if="isTimerRunning"
                  @click="handleStopTimer"
                  class="bg-white text-red-600 px-8 py-3 rounded-lg font-semibold hover:bg-red-50 transition flex items-center gap-2"
                >
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 10a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1v-4z" />
                  </svg>
                  Stop Timer
                </button>
              </div>
            </div>
          </div>

          <!-- Stats Cards -->
          <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
            <div class="bg-white rounded-lg shadow p-6">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm font-medium text-gray-600">Today</p>
                  <p class="text-2xl font-bold text-gray-900 mt-1">
                    {{ formatDuration(getTotalTimeToday()) }}
                  </p>
                </div>
                <div class="bg-blue-100 p-3 rounded-lg">
                  <svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                </div>
              </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm font-medium text-gray-600">This Week</p>
                  <p class="text-2xl font-bold text-gray-900 mt-1">
                    {{ formatDuration(getTotalTimeThisWeek()) }}
                  </p>
                </div>
                <div class="bg-green-100 p-3 rounded-lg">
                  <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                  </svg>
                </div>
              </div>
            </div>

            <div class="bg-white rounded-lg shadow p-6">
              <div class="flex items-center justify-between">
                <div>
                  <p class="text-sm font-medium text-gray-600">Total Entries</p>
                  <p class="text-2xl font-bold text-gray-900 mt-1">
                    {{ timeEntries.length }}
                  </p>
                </div>
                <div class="bg-purple-100 p-3 rounded-lg">
                  <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                  </svg>
                </div>
              </div>
            </div>
          </div>

          <!-- Quick Start from Tasks -->
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">Quick Start</h3>
              <p class="text-sm text-gray-600">Start tracking time for your tasks</p>
            </div>
            <div class="p-6">
              <div v-if="incompleteTasks.length === 0" class="text-center py-8 text-gray-500">
                <p>No tasks available. Create tasks first!</p>
                <router-link to="/tasks" class="text-blue-600 hover:text-blue-700 text-sm mt-2 inline-block">
                  Go to Tasks →
                </router-link>
              </div>
              <div v-else class="grid gap-3 sm:grid-cols-2">
                <button
                  v-for="task in incompleteTasks.slice(0, 6)"
                  :key="task.id"
                  @click="handleStartFromTask(task)"
                  :disabled="isTimerRunning"
                  class="text-left p-4 border-2 border-gray-200 rounded-lg hover:border-blue-500 hover:bg-blue-50 transition disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <div class="flex items-start gap-3">
                    <div
                      :class="[
                        'w-2 h-2 rounded-full mt-2 flex-shrink-0',
                        task.priority === 'high' ? 'bg-red-500' :
                        task.priority === 'medium' ? 'bg-yellow-500' : 'bg-green-500'
                      ]"
                    ></div>
                    <div class="flex-1 min-w-0">
                      <p class="font-medium text-gray-900">{{ task.title }}</p>
                      <p class="text-sm text-gray-500 mt-1">Due: {{ formatDate(task.dueDate) }}</p>
                    </div>
                  </div>
                </button>
              </div>
            </div>
          </div>

          <!-- Time Entries History -->
          <div class="bg-white rounded-lg shadow">
            <div class="px-6 py-4 border-b border-gray-200">
              <h3 class="text-lg font-semibold text-gray-900">Time Entries</h3>
            </div>
            <div class="p-6">
              <div v-if="timeEntries.length === 0" class="text-center py-8 text-gray-500">
                <p>No time entries yet</p>
              </div>
              <div v-else class="space-y-3">
                <div
                  v-for="entry in timeEntries"
                  :key="entry.id"
                  class="flex items-center justify-between p-4 border border-gray-200 rounded-lg hover:bg-gray-50 transition"
                >
                  <div class="flex-1">
                    <p class="font-medium text-gray-900">{{ entry.taskTitle }}</p>
                    <p v-if="entry.description" class="text-sm text-gray-600 mt-1">
                      {{ entry.description }}
                    </p>
                    <div class="flex items-center gap-4 mt-2 text-sm text-gray-500">
                      <span>{{ formatDateTime(entry.startTime) }}</span>
                      <span v-if="entry.endTime">→ {{ formatTime(entry.endTime) }}</span>
                    </div>
                  </div>
                  <div class="flex items-center gap-4">
                    <div class="text-right">
                      <p class="text-lg font-semibold text-gray-900">
                        {{ formatDuration(entry.duration) }}
                      </p>
                    </div>
                    <button
                      @click="handleDeleteEntry(entry.id)"
                      class="p-2 text-red-600 hover:bg-red-50 rounded transition"
                      title="Delete"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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

    <!-- Start Timer Dialog -->
    <div
      v-if="showStartDialog"
      class="fixed inset-0 bg-black bg-opacity-50 z-50 flex items-center justify-center p-4"
      @click.self="showStartDialog = false"
    >
      <div class="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
        <h3 class="text-xl font-semibold text-gray-900 mb-4">Start Timer</h3>

        <div class="space-y-4">
          <div>
            <label for="task-title" class="block text-sm font-medium text-gray-700 mb-2">
              Task Name <span class="text-red-500">*</span>
            </label>
            <input
              id="task-title"
              v-model="newTimerTask"
              type="text"
              required
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              placeholder="What are you working on?"
            />
          </div>

          <div>
            <label for="task-description" class="block text-sm font-medium text-gray-700 mb-2">
              Description (optional)
            </label>
            <textarea
              id="task-description"
              v-model="newTimerDescription"
              rows="3"
              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent resize-none"
              placeholder="Add details..."
            />
          </div>
        </div>

        <div class="flex gap-3 mt-6">
          <button
            @click="handleStartManualTimer"
            :disabled="!newTimerTask"
            class="flex-1 bg-green-600 hover:bg-green-700 text-white font-medium py-2.5 px-4 rounded-lg transition disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Start Timer
          </button>
          <button
            @click="showStartDialog = false"
            class="px-6 py-2.5 text-gray-700 hover:bg-gray-100 rounded-lg transition font-medium"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </SideNav>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useTimer } from '../composables/useTimer'
import { useTasks, Task } from '../composables/useTasks'
import SideNav from '../components/SideNav.vue'

const { tasks } = useTasks()
const {
  timeEntries,
  activeEntry,
  elapsedTime,
  isTimerRunning,
  startTimeEntry,
  stopTimeEntry,
  deleteTimeEntry,
  formatDuration,
  getTotalTimeToday,
  getTotalTimeThisWeek
} = useTimer()

const showStartDialog = ref(false)
const newTimerTask = ref('')
const newTimerDescription = ref('')

const incompleteTasks = computed(() => {
  return tasks.value.filter(t => t.status !== 'completed')
})

const formatDisplayTime = (seconds: number): string => {
  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60

  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
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
    day: 'numeric'
  })
}

const formatDateTime = (dateString: string): string => {
  const date = new Date(dateString)
  return date.toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const formatTime = (dateString: string): string => {
  const date = new Date(dateString)
  return date.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit'
  })
}

const handleStartFromTask = async (task: Task) => {
  await startTimeEntry(task.title, task.id)
}

const handleStartManualTimer = async () => {
  if (!newTimerTask.value) return

  await startTimeEntry(
    newTimerTask.value,
    undefined,
    newTimerDescription.value || undefined
  )

  newTimerTask.value = ''
  newTimerDescription.value = ''
  showStartDialog.value = false
}

const handleStopTimer = async () => {
  await stopTimeEntry()
}

const handleDeleteEntry = async (id: number) => {
  if (confirm('Are you sure you want to delete this time entry?')) {
    await deleteTimeEntry(id)
  }
}
</script>
