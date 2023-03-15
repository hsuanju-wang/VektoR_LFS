using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public AudioSource audioSource;
    public AudioClip doorOpen;
    public AudioClip controllerScan;
    public AudioClip powerOn;
    public AudioClip teleport;

    
    // Start is called before the first frame update
    void Start()
    {

    }

    public void PlaySound(AudioClip audioClip)
    {
        audioSource.clip = audioClip;
        audioSource.Play();
    }
    public void PlayDoorOpen()
    {
        PlaySound(doorOpen);
    }

    public float PlayControllerScan()
    {
        PlaySound(controllerScan);
        return controllerScan.length;
    }

    public float PlayPowerOn()
    {
        PlaySound(powerOn);
        return powerOn.length;
    }

    public void PlayTeleport()
    {
        PlaySound(teleport);
    }
}
