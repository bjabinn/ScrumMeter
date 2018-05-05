
import { Injectable, Inject } from '@angular/core';
import { User } from '../login/User'; 

@Injectable()
export class StorageDataService{
    public UserProjects: any = [];
    public UserProjectSelected;
    public UserData: User;
    public DataUnfinished: boolean = false;
    public IdSection: number = 1;
}
