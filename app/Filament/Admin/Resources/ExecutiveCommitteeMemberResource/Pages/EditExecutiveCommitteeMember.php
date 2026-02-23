<?php

namespace App\Filament\Admin\Resources\ExecutiveCommitteeMemberResource\Pages;

use App\Filament\Admin\Resources\ExecutiveCommitteeMemberResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditExecutiveCommitteeMember extends EditRecord
{
    protected static string $resource = ExecutiveCommitteeMemberResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
}
