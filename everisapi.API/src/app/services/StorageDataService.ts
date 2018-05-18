
import { Injectable, Inject } from '@angular/core';
import { User } from 'app/Models/User'; 
import { Evaluacion } from 'app/Models/Evaluacion';
import { EvaluacionInfo } from 'app/Models/EvaluacionInfo';
import { Proyecto } from 'app/Models/Proyecto';
import { Section } from 'app/Models/Section';

@Injectable()
export class StorageDataService{
    public UserProjects: any = [];
    public UserProjectSelected: Proyecto = { id: -1, fecha: null, nombre: '' };
    public UserData: User;
    public DataUnfinished: boolean = false;
    public SectionSelected: Section = null;
    public Evaluacion: Evaluacion = null;
    public EvaluacionToPDF: EvaluacionInfo = null;
    public SectionName: string = null;
}
