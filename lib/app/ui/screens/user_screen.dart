import 'package:flutter/material.dart';
import 'package:poliglotim/app/ui/core/themes/neumorphic.dart'; // Замените your_app на название вашего приложения
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        final padding = isSmall ? 16.0 : 32.0;
        final avatarSize = isSmall ? 80.0 : 120.0;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 1200,
                  minHeight: constraints.maxHeight,
                ),
                child: isSmall
                    ? _buildMobileLayout(context, avatarSize)
                    : _buildDesktopLayout(context, avatarSize),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context, double avatarSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildProfilePanel(context, avatarSize),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: _buildProgressPanel(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, double avatarSize) {
    return Column(
      children: [
        _buildProfilePanel(context, avatarSize),
        const SizedBox(height: 24),
        _buildProgressPanel(context),
      ],
    );
  }

  // Панель профиля с балансом и статистикой
  Widget _buildProfilePanel(BuildContext context, double avatarSize) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: Neumorphic.panel(context),
      child: Column(
        children: [
          // Аватар
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: Neumorphic.panel(
              context,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.transparent,
              child: Icon(
                Icons.person,
                size: avatarSize * 0.6,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Имя пользователя
          Text(
            'Алексей Иванов',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'alexey@email.com',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
          const SizedBox(height: 16),

          // Статус и уровень
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: Neumorphic.panel(
              context,
              isPressed: true,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Уровень 12 · Intermediate',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Баланс и монеты
          Container(
            padding: const EdgeInsets.all(16),
            decoration: Neumorphic.panel(context, isHovered: true),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Colors.amber[600],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Баланс',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                      '1 250 ₽',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Colors.purple[400],
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Очки опыта',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                      '8 450',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple[400],
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Статистика в виде сетки
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
            children: [
              _buildStatItem(context, '📚 Слова', '1 234'),
              _buildStatItem(context, '🎯 Точность', '87%'),
              _buildStatItem(context, '🔥 Дней подряд', '45'),
              _buildStatItem(context, '⏱️ Часов', '126'),
            ],
          ),
          const SizedBox(height: 16),

          // Кнопка пополнения
          _buildActionButton(
            context,
            '💰 Пополнить баланс',
            Icons.add_circle_outline,
            () {},
          ),
        ],
      ),
    );
  }

  // Панель с прогрессом и достижениями
  Widget _buildProgressPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: Neumorphic.panel(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Text(
            'ПРОГРЕСС',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
          ),
          const SizedBox(height: 16),

          // Прогресс по курсу
          _buildProgressCard(
            context,
            'Английский язык · Intermediate',
            '8 из 15 уроков',
            0.53,
            Icons.menu_book,
          ),
          const SizedBox(height: 12),
          _buildProgressCard(
            context,
            'Грамматика: Present Perfect',
            '5 из 6 тем',
            0.83,
            Icons.g_translate,
          ),
          const SizedBox(height: 12),
          _buildProgressCard(
            context,
            'Словарный запас',
            '45 из 100 слов',
            0.45,
            Icons.auto_awesome,
          ),
          const SizedBox(height: 24),

          // Достижения
          Row(
            children: [
              Text(
                'ДОСТИЖЕНИЯ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('Все достижения →'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Список достижений
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildAchievementItem(
                context,
                Icons.emoji_events,
                'Первые 100 слов',
                true,
                Colors.amber,
              ),
              _buildAchievementItem(
                context,
                Icons.local_fire_department,
                '7 дней подряд',
                true,
                Colors.orange,
              ),
              _buildAchievementItem(
                context,
                Icons.school,
                '10 уроков пройдено',
                true,
                Colors.blue,
              ),
              _buildAchievementItem(
                context,
                Icons.star,
                'Отлично! 90% точности',
                false,
                Colors.grey,
              ),
              _buildAchievementItem(
                context,
                Icons.groups,
                'Курс завершён',
                false,
                Colors.grey,
              ),
              _buildAchievementItem(
                context,
                Icons.rocket,
                'Новичок → Intermediate',
                false,
                Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Кнопки быстрых действий
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context,
                  '📖 Мои курсы',
                  Icons.menu_book,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  '📊 Статистика',
                  Icons.bar_chart,
                  () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context,
                  '🏆 Рейтинг',
                  Icons.leaderboard,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context,
                  '⚙️ Настройки',
                  Icons.settings,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Вспомогательные виджеты
  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: Neumorphic.panel(context, isPressed: true),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String title,
    String subtitle,
    double progress,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: Neumorphic.panel(context, isHovered: true),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Theme.of(context).colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isUnlocked,
    Color color,
  ) {
    return Container(
      decoration: Neumorphic.panel(
        context,
        isHovered: isUnlocked,
        isPressed: !isUnlocked,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: isUnlocked ? color : Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isUnlocked
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey[400],
                ),
          ),
          if (!isUnlocked) ...[
            const SizedBox(height: 2),
            Icon(
              Icons.lock_outline,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: Neumorphic.panel(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: Neumorphic.panel(context, isHovered: true),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}