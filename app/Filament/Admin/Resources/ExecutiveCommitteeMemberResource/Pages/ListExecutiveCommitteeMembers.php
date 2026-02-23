<?php

namespace App\Filament\Admin\Resources\ExecutiveCommitteeMemberResource\Pages;

use App\Filament\Admin\Resources\ExecutiveCommitteeMemberResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListExecutiveCommitteeMembers extends ListRecords
{
    protected static string $resource = ExecutiveCommitteeMemberResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
