declare namespace User {

type Gender = 'Male' | 'Female' | 'Other'
type UserType = 'Client'|  'Agri-Expert'| 'Admin'

    interface UserData {
        id: string | null;
        firstName: string | null;
        lastName: string | null;
        email: string | null;
        password: string | null;
        avatarUrl: string | null;
      
        dateOfBirth: string | null;
        state: boolean | null;
        gender: Gender | null;
        userType: UserType | null;
        country: string | null;
        createdAt: string | null;
        updatedAt: string | null;
    }

    interface User {
        firstName: string | null;
        lastName: string | null;
        email: string | null;
        password: string | null;
    }


    interface UserAuth {
        firstName?: string
        lastName?: string
        email?: string
        password?: string
        reenteredPassword?: string
    }
}