<?php

namespace App\Filament\Admin\Resources\NoticeResource\Pages;

use App\Filament\Admin\Resources\NoticeResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListNotices extends ListRecords
{
    protected static string $resource = NoticeResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
