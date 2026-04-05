<?php

namespace App\Filament\Admin\Widgets;

use Filament\Widgets\ChartWidget;
use App\Models\Member;
use App\Models\Notice;
use App\Models\Publication;

class StatsOverviewWidget extends ChartWidget
{
    protected static ?string $heading = 'Website Statistics';

    public function getDescription(): ?string
    {
        return 'Overview of your website data';
    }

    protected function getData(): array
    {
        return [
            'datasets' => [
                [
                    'label' => 'Members',
                    'data' => [Member::count()],
                    'backgroundColor' => '#3b82f6',
                ],
                [
                    'label' => 'Notices',
                    'data' => [Notice::count()],
                    'backgroundColor' => '#10b981',
                ],
                [
                    'label' => 'Publications',
                    'data' => [Publication::count()],
                    'backgroundColor' => '#f59e0b',
                ],
            ],
            'labels' => ['Total'],
        ];
    }

    protected function getType(): string
    {
        return 'bar';
    }
}
