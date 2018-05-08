
import { Injectable, Inject } from '@angular/core';
import { User } from 'app/Models/User'; 
import { Evaluacion } from 'app/Models/Evaluacion';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';

@Injectable()
export class StorageDataService{
    public UserProjects: any = [];
    public UserProjectSelected;
    public UserData: User;
    public DataUnfinished: boolean = false;
    public IdSection: number = 1;
    public Evaluacion: Evaluacion = null;
    public EvaluacionToPDF: EvaluacionInfo = null;
}
