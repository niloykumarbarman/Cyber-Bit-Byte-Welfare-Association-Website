<?php

namespace App\Filament\Admin\Resources\NoticeResource\Pages;

use App\Filament\Admin\Resources\NoticeResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditNotice extends EditRecord
{
    protected static string $resource = NoticeResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
