# Landmark
# Планировщик периодических задач по времени

### Принцип работы

Планировщик по расписанию пушит события в выделенный exchange RabbitMQ по индивидуальному ключу.
Для организации работы следует подписаться на exchange по требуемому ключу, создав свою очередь.

### Пример расписания

```
  minute: [1, 2, 3, 5, 8, 13, 21, 34],
  hour: [1],
  day: [1],
  at: ['23:02']
```

Это означает что объявлены 10 повторяемых интервалов в своих группах (минута, час, день) и один фиксированный `at` который выполнится в конкретное время.

#### Для повторяемых интервалов пример работы используя Sneakers:
```
class PeriodicWorker
  include Sneakers::Worker

  from_queue 'periodic.1hour', exchange: 'landmark.timers',
                               exchange_type: :direct,
                               routing_key: '1hour'

  def perform(msg)
    # msg = { timestamp: 1507234560, interval: '1hour' }
    # do_the_work
    ack!
  end
end
```

#### Для фиксированных интервалов пример работы используя Sneakers:
```
class FixedWorker
  include Sneakers::Worker

  from_queue 'specific.22_15', exchange: 'landmark.timers',
                               exchange_type: :direct,
                               routing_key: 'at_22_15'

  def perform(msg)
    # msg = { timestamp: 1507230900, interval: 'at_22_15' }
    # do_the_work
    ack!
  end
end
```

### Изменение расписания
После изменения расписания требуется передеплой.

### Запуск
`bundle exec ruby landmark.rb`
