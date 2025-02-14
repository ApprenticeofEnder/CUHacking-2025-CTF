export interface NoticeCreate {
	title: string;
	note: string;
	author: string;
}

export interface Notice extends NoticeCreate {
	id: number;
}
