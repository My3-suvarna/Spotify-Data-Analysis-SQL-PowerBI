SELECT * FROM public.spotify
LIMIT 100;

--EDA
SELECT count(*) from public.spotify;

SELECT count(DISTINCT ARTIST) from public.spotify;

SELECT DISTINCT album_type from public.spotify;

select max(duration_min) from spotify;
select min(duration_min) from spotify;
select * from spotify
where duration_min=0;

delete from spotify where duration_min=0;
select * from spotify
where duration_min=0;

SELECT count(*) from public.spotify;

SELECT DISTINCT channel from spotify;

SELECT DISTINCT most_played_on from public.spotify;
-------------------------------
--data analysis easy category
-----------------------------------
---1.Retrieve the names of all tracks that have more than 1 billion streams.
select * from spotify
where stream>1000000000;

---2.List all albums along with their respective artists.
SELECT DISTINCT album,artist 
from spotify;

---3.Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total
from spotify 
where licensed=TRUE;

---4.Find all tracks that belong to the album type single.
select * from spotify 
where album_type='single';

---5.Count the total number of tracks by each artist.
select count(track),artist
from spotify
group by artist;

-----------------------------------------
---Medium Level
--------------------------------------------
----1.Calculate the average danceability of tracks in each album.
select avg(danceability),album
from spotify
group by album;

---2.Find the top 5 tracks with the highest energy values.
select track,energy
from spotify
order by energy desc limit 5;

---3.List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views),sum(likes)
from spotify
where official_video='true'
group  by 1;

---4.For each album, calculate the total views of all associated tracks.
select album,track,sum(views) as total_view 
from spotify
group by 1,2
order by 3 desc;

---5.Retrieve the track names that have been streamed on Spotify more than YouTube.
select * from
(select track,
coalesce(sum(case when most_played_on='Youtube' then stream end),0)as stream_on_youtube,
coalesce(sum(case when most_played_on='Spotify' then stream end),0) as stream_on_spotify
from spotify
group by 1)
as t1
where stream_on_spotify>stream_on_youtube and
stream_on_youtube<>0;

--------------------------------
-------Advanced Level
--------------------------------
---Find the top 3 most-viewed tracks for each artist using window functions.
select 
	artist,
	track,
	sum(views),
	DENSE_RANK() over(partition by artist order by sum(views)desc) as rank
from spotify
group  by 1,2
order by 1,3;
