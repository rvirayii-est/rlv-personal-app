<template>
  <div class="bg-white rounded-lg shadow-md p-6">
    <!-- Calendar Header -->
    <div class="flex items-center justify-between mb-6">
      <button
        @click="previousMonth"
        class="p-2 hover:bg-gray-100 rounded transition"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
        </svg>
      </button>

      <h3 class="text-xl font-semibold text-gray-900">
        {{ monthName }} {{ currentYear }}
      </h3>

      <button
        @click="nextMonth"
        class="p-2 hover:bg-gray-100 rounded transition"
      >
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
        </svg>
      </button>
    </div>

    <!-- Calendar Grid -->
    <div class="grid grid-cols-7 gap-2">
      <!-- Day headers -->
      <div
        v-for="day in dayNames"
        :key="day"
        class="text-center text-sm font-semibold text-gray-600 py-2"
      >
        {{ day }}
      </div>

      <!-- Calendar days -->
      <div
        v-for="(day, index) in calendarDays"
        :key="index"
        :class="[
          'min-h-[100px] border rounded-lg p-2 transition',
          day.isCurrentMonth ? 'bg-white border-gray-200' : 'bg-gray-50 border-gray-100',
          day.isToday ? 'ring-2 ring-blue-500' : '',
          'hover:shadow-md cursor-pointer'
        ]"
        @click="selectDate(day)"
      >
        <div class="flex justify-between items-start mb-1">
          <span
            :class="[
              'text-sm font-medium',
              day.isCurrentMonth ? 'text-gray-900' : 'text-gray-400',
              day.isToday ? 'bg-blue-500 text-white w-6 h-6 rounded-full flex items-center justify-center' : ''
            ]"
          >
            {{ day.date.getDate() }}
          </span>
        </div>

        <!-- Tasks for this day -->
        <div class="space-y-1">
          <div
            v-for="task in day.tasks.slice(0, 3)"
            :key="task.id"
            :class="[
              'text-xs p-1 rounded truncate',
              getPriorityColor(task.priority),
              task.status === 'completed' ? 'opacity-60 line-through' : ''
            ]"
            :title="task.title"
            @click.stop="$emit('edit', task)"
          >
            {{ task.title }}
          </div>
          <div
            v-if="day.tasks.length > 3"
            class="text-xs text-gray-500 pl-1"
          >
            +{{ day.tasks.length - 3 }} more
          </div>
        </div>
      </div>
    </div>

    <!-- Legend -->
    <div class="mt-6 flex flex-wrap gap-4 text-sm">
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded bg-red-100"></div>
        <span class="text-gray-600">High Priority</span>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded bg-yellow-100"></div>
        <span class="text-gray-600">Medium Priority</span>
      </div>
      <div class="flex items-center gap-2">
        <div class="w-4 h-4 rounded bg-green-100"></div>
        <span class="text-gray-600">Low Priority</span>
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
  dateSelected: [date: string]
}>()

const currentMonth = ref(new Date().getMonth())
const currentYear = ref(new Date().getFullYear())

const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

const monthName = computed(() => {
  return new Date(currentYear.value, currentMonth.value).toLocaleString('en-US', { month: 'long' })
})

interface CalendarDay {
  date: Date
  isCurrentMonth: boolean
  isToday: boolean
  tasks: Task[]
}

const calendarDays = computed(() => {
  const days: CalendarDay[] = []
  const firstDay = new Date(currentYear.value, currentMonth.value, 1)
  const lastDay = new Date(currentYear.value, currentMonth.value + 1, 0)
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  // Get the day of the week for the first day (0 = Sunday)
  const startDay = firstDay.getDay()

  // Add days from previous month
  const prevMonthLastDay = new Date(currentYear.value, currentMonth.value, 0)
  for (let i = startDay - 1; i >= 0; i--) {
    const date = new Date(currentYear.value, currentMonth.value - 1, prevMonthLastDay.getDate() - i)
    days.push({
      date,
      isCurrentMonth: false,
      isToday: false,
      tasks: getTasksForDate(date)
    })
  }

  // Add days from current month
  for (let i = 1; i <= lastDay.getDate(); i++) {
    const date = new Date(currentYear.value, currentMonth.value, i)
    const dateOnly = new Date(date)
    dateOnly.setHours(0, 0, 0, 0)
    days.push({
      date,
      isCurrentMonth: true,
      isToday: dateOnly.getTime() === today.getTime(),
      tasks: getTasksForDate(date)
    })
  }

  // Add days from next month to complete the grid
  const remainingDays = 42 - days.length // 6 rows * 7 days
  for (let i = 1; i <= remainingDays; i++) {
    const date = new Date(currentYear.value, currentMonth.value + 1, i)
    days.push({
      date,
      isCurrentMonth: false,
      isToday: false,
      tasks: getTasksForDate(date)
    })
  }

  return days
})

const getTasksForDate = (date: Date): Task[] => {
  const dateString = date.toISOString().split('T')[0]
  return props.tasks.filter(task => task.dueDate === dateString)
}

const getPriorityColor = (priority: Task['priority']): string => {
  switch (priority) {
    case 'high':
      return 'bg-red-100 text-red-800 border-l-2 border-red-500'
    case 'medium':
      return 'bg-yellow-100 text-yellow-800 border-l-2 border-yellow-500'
    case 'low':
      return 'bg-green-100 text-green-800 border-l-2 border-green-500'
    default:
      return 'bg-gray-100 text-gray-800'
  }
}

const previousMonth = () => {
  if (currentMonth.value === 0) {
    currentMonth.value = 11
    currentYear.value--
  } else {
    currentMonth.value--
  }
}

const nextMonth = () => {
  if (currentMonth.value === 11) {
    currentMonth.value = 0
    currentYear.value++
  } else {
    currentMonth.value++
  }
}

const selectDate = (day: CalendarDay) => {
  const dateString = day.date.toISOString().split('T')[0]
  emit('dateSelected', dateString)
}
</script>
